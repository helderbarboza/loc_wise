# Desafio 

**API de CRUD de localidades com integração com a API do IBGE.**

Desenvolver uma solução para gerenciamento de localidades, implementando as 
operações básicas de CRUD para municípios e estados e filtros de pesquisa.

## Funcionalidades

### 1. Autenticação e autorização

- Cadastro básico de usuário (login, senha)
- Login (Básico, JWT ou Token)

### 2. CRUD das localidades

- Desenvolver operações de criação, leitura, atualização e exclusão (CRUD) para
  as entidades cidade e estado.

### 3. Pesquisa de municípios

- Os usuários podem inserir um nome ou código de um município brasileiro para
  realizar uma pesquisa.

### 4. Pesquisa de estados

- Os usuários podem inserir um nome ou código de um estado brasileiro para 
  realizar uma pesquisa

### 5. Integração com a API do IBGE

- Integre com a API pública do IBGE para buscar informações sobre os municípios 
  e estados brasileiros. Utilize essa integração par importar alguns dados para
  o funcionamento da aplicação.
- Garanta que ao realizar as importações os dados não sejam duplicados.
- Certifique-se de fazer solicitações apropriadas para obter dados detalhados
  sobre os municípios

### 6. Interface de usuário

- Desenvolva uma interface de usuário atraente e responsiva para as operações de
  CRUD e consulta de informações.
- Os resultados da pesquisa são exibidos em uma lista, mostrando o nome do 
  município, o estado e uma breve descrição.
- Ao clicar em um município na lista de resultados, os usuários podem acessar
  uma página de detalhes que exibe informações mais abrangentes sobre o
  município.
- As informações detalhadas podem incluir dados populacionais, geográficos e 
  outros dados disponíveis na API do IBGE.

## Requisitos

- O aplicativo deve ser construído usando uma tecnologia de desenvolvimento web
  à escolha do candidato (por exemplo: React.js, Vue.js, Angular, Node.js, etc.)
- O código do aplicativo deve estar hospedado em um repositório público ou 
  privado no GitHub.
- Garanta que o aplicativo seja executável e funcione corretamente.
- Adicione comentários e documentação adequada ao código.
- Utilize boas práticas de desenvolvimento de uma API.
  - Padronização de respostas
  - Documentação (Swagger)
  - Versionamento
  - Versione o código usando Git e disponibilize-o em um repositório GitHub. 
    Certifique-se de que o repositório esteja devidamente documentado. Utilize
    conveções como conventional commits para organizar seus commits.

## Dicas

- Leia a documentação da API do IBGE para entender como fazer solicitações e
  quais endpoints são relevantes para sua aplicação
- Planeje a estrutura do projeto de forma organizada, usnado pastas e arquivos 
  apropriados.
- Siga as melhores práticas de desenvolvimento web e escreva código limpo e 
  organizado.
- Mantenha o repositório do GitHub atualizado com commits frequentes e mensagens
  descritivas.
- Documente o README com instruções claras sobre como executar o aplicativo
  localmente.
