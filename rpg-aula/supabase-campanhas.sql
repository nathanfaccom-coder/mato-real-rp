-- Crônicas da Sala: campanhas e fichas sincronizadas
-- Execute em um projeto Supabase NOVO, escolhido e autorizado pelo proprietário.
-- Requer login anônimo do Supabase Auth habilitado no projeto.
create table if not exists public.rpg_campaigns (
 id uuid primary key default gen_random_uuid(),
 master_id uuid not null references auth.users(id) on delete cascade,
 name text not null check (char_length(name) between 2 and 80),
 join_code text not null unique check (join_code ~ '^[A-Z2-9]{8}$'),
 created_at timestamptz not null default now()
);
create table if not exists public.rpg_characters (
 id uuid primary key default gen_random_uuid(),
 campaign_id uuid not null references public.rpg_campaigns(id) on delete cascade,
 player_id uuid not null references auth.users(id) on delete cascade,
 sheet jsonb not null check (jsonb_typeof(sheet)='object' and octet_length(sheet::text) <= 25000),
 updated_at timestamptz not null default now(),
 unique(campaign_id,player_id)
);
create index if not exists rpg_characters_campaign_idx on public.rpg_characters(campaign_id);
alter table public.rpg_campaigns enable row level security;
alter table public.rpg_characters enable row level security;
revoke all on table public.rpg_campaigns from anon, authenticated;
revoke all on table public.rpg_characters from anon, authenticated;
grant select, insert on public.rpg_campaigns to authenticated;
grant select on public.rpg_characters to authenticated;
create policy "mestre_ve_suas_campanhas" on public.rpg_campaigns for select to authenticated
using (master_id = (select auth.uid()));
create policy "mestre_cria_sua_campanha" on public.rpg_campaigns for insert to authenticated
with check (master_id = (select auth.uid()));
create policy "ficha_visivel_para_aluno_e_mestre" on public.rpg_characters for select to authenticated
using (player_id = (select auth.uid()) OR exists (
 select 1 from public.rpg_campaigns c
 where c.id = campaign_id and c.master_id = (select auth.uid())
));
-- Responde apenas aos usuários autenticados que conhecem o código da campanha.
create or replace function public.rpg_find_campaign(p_code text)
returns table(campaign_id uuid, campaign_name text)
language plpgsql stable security definer set search_path=''
as $$
begin
 if auth.uid() is null then raise exception 'Autenticação obrigatória'; end if;
 return query select c.id, c.name from public.rpg_campaigns c
 where c.join_code=upper(trim(p_code)) limit 1;
end;
$$;
-- Adesão requer código: não é possível inserir fichas diretamente pela API.
create or replace function public.rpg_join_campaign(p_code text, p_sheet jsonb)
returns table(character_id uuid, campaign_id uuid)
language plpgsql security definer set search_path=''
as $$
declare v_campaign uuid; v_character uuid; v_user uuid := auth.uid();
begin
 if v_user is null then raise exception 'Autenticação obrigatória'; end if;
 if p_sheet is null or jsonb_typeof(p_sheet)<>'object'
   or nullif(btrim(p_sheet->>'name'),'') is null
   or char_length(p_sheet->>'name')>80 or octet_length(p_sheet::text)>25000
   then raise exception 'Ficha inválida'; end if;
 select c.id into v_campaign from public.rpg_campaigns c
 where c.join_code=upper(trim(p_code)) limit 1;
 if v_campaign is null then raise exception 'Código da campanha não encontrado'; end if;
 insert into public.rpg_characters(campaign_id,player_id,sheet)
 values (v_campaign,v_user,p_sheet)
 on conflict (campaign_id,player_id) do update
   set sheet=excluded.sheet,updated_at=now()
 returning id into v_character;
 return query select v_character,v_campaign;
end;
$$;
-- Ficha só pode ser atualizada pelo próprio aluno autenticado.
create or replace function public.rpg_save_character(p_character_id uuid, p_sheet jsonb)
returns boolean language plpgsql security definer set search_path=''
as $$
declare v_user uuid := auth.uid(); v_count integer;
begin
 if v_user is null then raise exception 'Autenticação obrigatória'; end if;
 if p_sheet is null or jsonb_typeof(p_sheet)<>'object'
   or nullif(btrim(p_sheet->>'name'),'') is null
   or char_length(p_sheet->>'name')>80 or octet_length(p_sheet::text)>25000
   then raise exception 'Ficha inválida'; end if;
 update public.rpg_characters
 set sheet=p_sheet,updated_at=now()
 where id=p_character_id and player_id=v_user;
 get diagnostics v_count=row_count;
 return v_count=1;
end;
$$;
revoke all on function public.rpg_find_campaign(text) from public, anon;
revoke all on function public.rpg_join_campaign(text,jsonb) from public, anon;
revoke all on function public.rpg_save_character(uuid,jsonb) from public, anon;
grant execute on function public.rpg_find_campaign(text) to authenticated;
grant execute on function public.rpg_join_campaign(text,jsonb) to authenticated;
grant execute on function public.rpg_save_character(uuid,jsonb) to authenticated;
alter publication supabase_realtime add table public.rpg_characters;
