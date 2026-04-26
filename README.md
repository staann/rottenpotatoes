# RottenPotatoes

Aplicação Ruby on Rails para gerenciamento de filmes, seguindo o fluxo CRUD do material do PDF (`new/create`, `edit/update`, `destroy`) com mensagens `flash`.

## Requisitos

- Ruby 3.4+
- Bundler
- SQLite3

## Setup

```powershell
bundle install
bundle exec rails db:migrate
```

## Executar localmente

```powershell
bundle exec rails server
```

Abra: `http://localhost:3000`

## Rodar testes

```powershell
bundle exec rails db:migrate RAILS_ENV=test
bundle exec rails test
```

## Funcionalidades implementadas

- Listagem de filmes (`/` e `/movies`)
- Cadastro de filme com campos `title`, `rating` e `release_date`
- Edição e atualização de filme
- Exclusão com confirmação
- Mensagens globais via `flash[:notice]` e `flash[:warning]`
