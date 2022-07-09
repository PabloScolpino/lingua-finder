# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.4.4'

gem 'pg'
gem 'puma', '~> 4.3'
gem 'rails', '~> 5.0.0'

# Error monitoring
gem 'lograge'
gem 'oj'
gem 'rollbar'

gem 'coffee-rails', '~> 4.2'
gem 'uglifier', '>= 1.3.0'

gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'

gem 'mongoid'

gem 'devise'
gem 'omniauth-google-oauth2'
gem 'responders', '< 3'

gem 'sidekiq', '< 6'

gem 'country_select'
gem 'material_icons'
gem 'materialize-sass'
gem 'sass-rails', '~> 5.0'
gem 'simple_form'
gem 'slim-rails'

gem 'google_custom_search_api'
gem 'httparty'

gem 'pragmatic_segmenter'
gem 'treetop'

group :test do
  gem 'database_cleaner'
  gem 'fakeredis'
  gem 'rails-controller-testing'
end

group :development, :test do
  gem 'awesome_print'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'fuubar'
  gem 'rerun'
  gem 'rspec-rails'
  gem 'ruby-prof', '>= 0.17.0', require: false
  gem 'simplecov'
  gem 'simplecov-lcov', '~> 0.8.0'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'listen', '~> 3.0.5'
  gem 'pry-rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
