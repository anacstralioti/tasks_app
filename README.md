<h1>Jurado App</h1>

O presente aplicativo surge pela necessidade de maior agilidade e eficiência no processo de julgamento no meio de competições. Visando trazer, desta forma, maior confiabilidade ao processo de avaliação e resultados, além de proporcionar uma melhor experiência para os jurados e participantes.

O projeto está sendo organizado a partir da ferramenta Trello (https://trello.com/invite/b/vUVLms64ATTIfd21679fcbaf7bf923abcf1a992575233FC97FA4/pac-iv). Tendo como foco de sua última versão: a inclusão de CRUD nas telas de cadastro de campeonato e cadastro de corporação. Cada tela vem sendo feita de forma meticulosa, visto que muitos dados dependem de outros para um funcionamento efetivo de CRUD. 

Este aplicativo possui as seguintes funcionalidades:

## Tela Introdutória:
- Botão que leva à tela de login;

## Tela de Login:
- Fazer login com e-mail e senha.

## Tela de Opções:
- Tela para cadastro e edição de campeonato, corporação, jurado, penalidades e impressão de relatórios. É importante frisar novamente que, até o momento, o foco de desenvolvimento do CRUD esteve apenas nas telas de campeonato e corporação.

## Tela de Cadastro Campeonato:
- Conta com cadastro de, por exemplo, edição do campeonato, data e CEP do local em que acontece o campeonato;

## Tela de Edição de Campeonatos Cadastrados:
- Fornece a opção de edição dos dados cadastrados.

## Tela de Cadastro de Corporação:
- Conta com cadastro de, por exemplo, nome da corporação, CEP do local em que a corporação se localiza, e-mail da corporação, entre outros. 

## Tela de Edição de Corporação:
- Fornece a opção de edição dos dados cadastrados.

## Como executar/importar o projeto:
- Certifique-se de que o Flutter esteja na versão 3.22.1 e o Dart na versão 3.4.1;
- Importe o projeto para sua IDE de preferência;
- Certifique-se de que a IDE esteja com os plugins Flutter e Dart instalados nas versões acima;
- Vá em `File > Settings > Languages & Frameworks > Flutter` e insira o caminho da pasta do SDK do Flutter em `Flutter SDK path`;
- Abra o arquivo `pubspec.yaml` e clique em `pub get` para que as dependências (pacotes) utilizadas no projeto sejam carregadas;
- Execute a aplicação.
