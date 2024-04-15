source "https://rubygems.org"
git_source(:github) do |repo|
  "https://github.com/#{repo}.git"
end

ruby ">= 3.0.0"

# Default gems generated by `rails new`
# asset-pipeline: propshaft
# javascript: esbuild
# css: sass

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3"

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"

# Use sqlite3 as the database for Active Record
# gem "sqlite3", "~> 1.4"
# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"
# Use postgresql as the database for Active Record
# gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Other gems

# Use Slim for HTML
gem "slim-rails"

# Cnofig
gem "config"

# Devise
gem "devise"
gem "devise_ldap_authenticatable"

# Pundit
gem "pundit"

# LDAP
gem "activeldap", require: "active_ldap/railtie"
gem "net-ldap"

# Queue backend
gem "delayed_job_active_record"
gem "delayed_job_web"
gem "daemons"

# i18n
gem "rails-i18n", "~> 7.0.0"
gem "devise-i18n"
gem "i18n-active_record", require: "i18n/active_record"

# Mustache
gem "mustache", "~> 1.0"

# mail
gem "mail-iso-2022-jp"

# pagination
gem "kaminari"

# whenever
gem "whenever", require: false

# unicode display width
gem "unicode-display_width"
gem "unicode-emoji"

# Bootstrap
gem "bootstrap_form", "~> 5.3"

# octicons
gem "octicons"
gem "octicons_helper"

# search
gem "ransack"

# default gem and bundled gem target Ruby 3.1
gem "psych", ">= 4.0.4"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # RuboCop / Formatter / Lint
  gem "rubocop"
  gem "rubocop-rails"
  gem "slim_lint"
  gem "guard"
  gem "guard-minitest"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end
