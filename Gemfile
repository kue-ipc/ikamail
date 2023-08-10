source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '>= 3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0.7'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3', '~> 1.4'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4'
# Use Puma as the app server
gem 'puma', '~> 5.6'
# Use Slim for HTML
gem 'slim-rails'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Transpile app-like JavaScript. From webpacker to shakapacker
# https://github.com/shakacode/shakapacker
gem 'shakapacker', '~> 7'
# Turbolinks makes navigating your web application faster. Read more:
#  https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Cnofig
gem 'config'

# Auth
gem 'devise'
gem 'devise_ldap_authenticatable'
gem 'pundit'

# LDAP
gem 'activeldap', require: 'active_ldap/railtie'
gem 'net-ldap'

# Queue backend
gem 'delayed_job_active_record'
gem 'delayed_job_web'
gem 'daemons'

# i18n
gem 'rails-i18n'
gem 'devise-i18n'
gem 'i18n-active_record', require: 'i18n/active_record'

# Mustache
gem 'mustache', '~> 1.0'

# mail
gem 'mail-iso-2022-jp'

# pagination
gem 'kaminari'

# whenever
gem 'whenever', require: false

# unicode display width
gem 'unicode-display_width'
gem 'unicode-emoji'

# bootstrap
gem 'bootstrap', '~> 5.1'
gem 'bootstrap_form', '~> 5.0'

# octicons
gem 'octicons'
gem 'octicons_helper'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'slim_lint'

  gem 'guard'
  gem 'guard-minitest'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
