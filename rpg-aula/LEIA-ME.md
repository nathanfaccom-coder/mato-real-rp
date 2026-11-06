# Crônicas da Sala — RPG rápido

Aplicativo educacional em um único arquivo HTML, sem instalação, sem login e sem dependências. Criado para sessões rápidas de RPG com alunos.

## O que já funciona

- Ficha interativa de aluno, compatível com celular.
- **20 raças** de fantasia, incluindo Fada, Tritão, Sereia, Centauro, Tabaxi, Golias, Aasimar, Genasi, Sátiro, Harengon, Forjado e Kenku, todas com traço narrativo e bônus de PV.
- **13 classes** de fantasia, incluindo Monge, Druida, Feiticeiro, Bruxo e Artífice.
- 4 habilidades iniciais por classe e 1 nova habilidade a cada nível (até o nível 5).
- Os 6 atributos de D&D (Força, Destreza, Constituição, Inteligência, Sabedoria e Carisma) são sorteados automaticamente para cada personagem usando 4d6, descartando o menor resultado de cada rolagem.
- Cada atributo mostra seus pontos (3–18), modificador de teste, exemplo dos tomates e botão de teste d20 + modificador.
- O aluno pode sortear novamente os seis atributos com confirmação; recomenda-se autorização do mestre.
- Os atributos são incluídos no link de compartilhamento e aparecem também no painel do mestre. Personagens antigos no mesmo celular recebem uma rolagem ao carregar a nova versão, sem perder nível, poderes ou PV.
- Pontos de vida, dano, cura, dados, quantidade de usos e descansos curto/longo.
- Salvamento local no navegador do aluno.
- Compartilhamento por link ou código, com painel do mestre para receber e consultar fichas.
- Exportação de backup do painel do mestre em JSON.

**Importante:** o painel do mestre usa cópias das fichas compartilhadas. Não existe atualização automática em tempo real; o aluno deve mandar um link novo após mudanças. Cada ficha fica armazenada apenas no aparelho que a criou. Recomendamos nomes fictícios ou apelidos, sem dados pessoais.

## Publicação pelo GitHub Pages

O site foi criado em `main/rpg-aula/index.html` para **não interferir nos projetos existentes**.

1. Abra as configurações deste repositório: https://github.com/nathanfaccom-coder/mato-real-rp/settings/pages
2. Em **Build and deployment**, selecione **Deploy from a branch**.
3. Selecione branch **main** e pasta **/(root)**. Clique em **Save**.
4. Aguarde a publicação (pode levar alguns minutos).
5. Acesse: https://nathanfaccom-coder.github.io/mato-real-rp/rpg-aula/

Alternativa offline: salve o arquivo `index.html` no aparelho e abra com o navegador. O botão de compartilhar exige hospedagem HTTPS para funcionar melhor; o código de ficha ainda pode ser copiado.

## Como usar na aula

1. Mostre o link do site, os alunos abrem em **Minha ficha** e preenchem nome fictício, raça e classe.
2. Cada aluno toca em **Compartilhar ficha** e envia o link por mensagem para você.
3. No seu celular, abra o link recebido: a ficha é adicionada automaticamente ao **Painel do mestre**.
4. O aluno reduz ou recupera PV e gasta poderes quando usa suas habilidades. Use **Descanso curto** e **Descanso longo**.
5. Quando ganhar nível, clique em **Subir de nível** e escolha 1 novo poder.
6. Para atualizar sua visão, peça ao aluno outro link após as mudanças.

## Regras usadas

As regras foram deliberadamente **simplificadas e inventadas para a aula**, com inspiração em RPGs de fantasia; **não são as regras oficiais de Dungeons & Dragons**. Acertar: role 1d20 e compare com CD 10 (fácil), 13 (média) ou 16 (difícil); dano é rolado conforme a habilidade. PV zerados significam personagem incapacitado. A decisão narrativa fica com o mestre.

## Próxima melhoria sugerida

Banco de dados e autenticação para visualizar as fichas **ao vivo** entre aparelhos e proteger o painel do mestre. Essa integração ainda **não está implementada**.
