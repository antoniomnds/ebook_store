source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.2"
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"
# Use sqlite3 as the database for Active Record [https://github.com/sparklemotion/sqlite3-ruby]
gem "sqlite3", ">= 1.4"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.14"

# Use Bootstrap styles for the frontend
gem "bootstrap", "~> 5.3.5"
gem "dartsass-sprockets"

# For image hosting and processing [https://cloudinary.com]
gem "cloudinary"

# For background processing
gem "sidekiq"

# For sending by default some headers that are required by rails, like X-CSRF-Token
gem "requestjs-rails"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  # gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "pry-byebug"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # Fake data generation for testing purposes
  gem "faker"

  # Load environment variables from .env into ENV in development [https://github.com/bkeepers/dotenv]
  gem "dotenv-rails"

  # For generating and running tests with RSpec [https://rspec.info/]
  gem "rspec-rails", "~> 8.0"

  # For generating factories in tests [https://github.com/thoughtbot/factory_bot]
  gem "factory_bot_rails"

  # For mocking HTTP requests in tests [https://github.com/bblimke/webmock]
  gem "webmock"

  # For analyzing test coverage [https://github.com/simplecov-ruby/simplecov]
  gem "simplecov", require: false

  # For capturing and testing emails in development [https://mailcatcher.me/]
  gem "mailcatcher", "~> 0.10"
end

group :test do
  # For simulating user interactions in tests [https://github.com/teamcapybara/capybara]
  gem "capybara"

  # For running tests in a browser [https://github.com/SeleniumHQ/selenium/tree/trunk/rb]
  gem "selenium-webdriver"

  # For opening the browser in tests [https://github.com/copiousfreetime/launchy]
  gem "launchy"

  # For running tests automatically when files change [
  gem "guard-rspec", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end
