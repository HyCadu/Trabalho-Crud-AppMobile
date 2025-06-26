# Matemágicas API - App Flutter

Este projeto é um aplicativo Flutter para controle de usuários (players) e jogos matemáticos, desenvolvido como trabalho do quinto período da faculdade.

## Funcionalidades
- Cadastro, edição e exclusão de usuários (players)
- Cadastro, edição e visualização de jogos matemáticos
- Persistência de dados tanto na nuvem quanto localmente

## Armazenamento de Dados
- **API:** Os dados são armazenados em um banco de dados **MongoDB** através de uma API REST hospedada no Render.
- **Local:** O app também armazena os dados dos usuários localmente usando o pacote **shared_preferences** do Flutter, permitindo acesso offline e maior velocidade de carregamento.

## Tecnologias Utilizadas
- Flutter
- Dart
- MongoDB (via API)
- shared_preferences

## Como rodar o projeto
1. Instale as dependências:
   ```
   flutter pub get
   ```
2. Execute o app:
   ```
   flutter run
   ```

## Observações
- A API pode demorar para responder caso esteja "adormecida" no Render.
- Usuários com menos de 6 anos (nascidos após 31/12/2019) não podem ser cadastrados.
- link apresentação canva: https://www.canva.com/design/DAGrdghjjkQ/hssHA-vFhWL9rWNHMABeWw/edit?utm_content=DAGrdghjjkQ&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton

---

Trabalho desenvolvido para a disciplina de Programação app Mobile - 5º período.
