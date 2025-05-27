# 📚 Ebook Store [![CI](https://github.com/antoniomnds/ebook_store/actions/workflows/ci.yml/badge.svg)](https://github.com/antoniomnds/ebook_store/actions/workflows/ci.yml) [![codecov](https://codecov.io/gh/antoniomnds/ebook_store/graph/badge.svg?token=4RCR91OHQG)](https://codecov.io/gh/antoniomnds/ebook_store)


A simple full-stack Rails application for managing ebooks, which can be bought/sold by users.

Built as a portfolio project to demonstrate testing practices, model design
(including polymorphic associations), and clean Rails architecture.

---

## 🚀 Features

- User authentication using `has_secure_password`
- Full CRUD for ebooks and users
- Tagging system with a polymorphic join model (`Tagging`)
- Email notifications on key events (e.g., user registration)
- Thorough test coverage using RSpec (models, requests, system, mailers, views, routing)
- Modern UI styled using Bootstrap
- Ready for CI and PostgreSQL migration

---

## 🔧 Setup

```bash
git clone https://github.com/antoniomnds/ebook_store.git
cd ebook_store
bundle install
rails db:setup
cp .env.example .env
```

> ⚠️ Note: App currently uses SQLite for local development. Plan includes migrating to PostgreSQL for production readiness.

---

## 🧪 Running Tests

```bash
bundle exec rspec
```

Optionally run `rubocop` code formatter:
```bash
bundle exec rubocop -a -f g
```

Coverage with:
```bash
open coverage/index.html
```


---

## 🛠️ Tech Stack
- [Ruby on Rails 7](https://github.com/rails/rails)
- [RSpec](https://github.com/rspec/rspec-rails), [SimpleCov](https://github.com/simplecov-ruby/simplecov)
- [SQLite](https://github.com/sparklemotion/sqlite3-ruby)
- [Bootstrap 5](https://github.com/twbs/bootstrap-rubygem)
- [FactoryBot](https://github.com/thoughtbot/factory_bot) 
- [Sidekiq](https://github.com/sidekiq/sidekiq)
- [dotenv-rails](https://github.com/bkeepers/dotenv)


---

## 🧠 Notable Design Choices
- Tagging is a polymorphic join model (ebooks, authors, etc.)
- System specs simulate real user behavior (login, navigation)
- View specs validate rendering of key UI elements
- Database constraints align with validations (e.g., uniqueness + unique index)


---

## 🚀 Deployment (Planned)

- PostgreSQL migration
- GitHub Actions CI pipeline with tests
- Deployment to Render, Fly.io or Railway

## 👤 Author

António Santos  
[LinkedIn](https://www.linkedin.com/in/antonio-dantas-santos/)
