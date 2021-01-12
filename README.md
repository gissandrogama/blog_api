# BlogApi

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

  ![logo-trybe](https://yt3.ggpht.com/ytc/AAUvwniKOMGxGD02USyXcic0VZEBJxLsGJNgD_20IrCNPA=s900-c-k-c0x00ffffff-no-rj)

# BlogApi

Desafio **bac-kend** que o objetivo é criar uma API API de um CRUD de posts de blog. Proposto pela [Trybe](https://www.betrybe.com/)

# Informacoes Tecnicas
* Ecossistema Elixir

## Iniciando a api localmente

**1.** Clone o projeto:

 * ssh
```sh
$ git clone git@github.com:gissandrogama/blog_api.git
```

 * https
```sh
$ git clone https://github.com/gissandrogama/blog_api.git
```

**2.** Acesse a pasta do projeto:

```sh
$ cd blog_api
```

**3.** Instale as dependências:

```sh
$ mix deps.get
```

**4.** criar e migrar o banco de dados, e inserir dados do db.json:

```sh
$ mix ecto.setup
```

**5.** inicie o endpoit phoenix com:

```sh
$ mix phx.sever
```

# Sobre API

Como foi requisitado nas especificações das funcionalidades do teste, a api possui os seguintes endpoints: **user**, **post**, **login** e **search** como mostra a tabela a seguir:

endpoint   | descrição | valores que podem ser passados para os parametros
--------- | ----------------------- | --------------
/api/user | nesse endpoint é possível lista todos os usuários, listar um usuário passando id, criar e deletar usando `user/me` |
/api/post | nesse endpoint é possível lista todos os posts, listar um post passando id, criar, modificar e deletar passando o id |
/api/login | nesse endpoint é passando como parametro `email` e `password`, se email e senha corespoderem a um usuário é gerado um token e uma sessão
/api/search | esse endpoint executa buscas por títulos e conteúdo dos posts


caso queira usar o insomnia, segue um arquivo já com as rotas para ultilizar
[arquivo insomnia](./Insomnia-blog_api.json)

# Deploy
A aplicação está no gigalixir no endereço <https//.gigalixirapp.com/>. Um dos motivos de escolher o gigalixir é que não tem sleeps da aplicação no plano free.

# Gerar documentação da aplicação

```sh
$ mix docs
```
