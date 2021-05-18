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

# Use SCSS for stylesheets
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# ODM database for page caching
gem 'mongoid'

# User login
gem 'devise'
gem 'omniauth-google-oauth2'
gem 'responders', '< 3'

# Queuing
gem 'sidekiq', '< 6'

# views
gem 'country_select'
gem 'material_icons'
gem 'materialize-sass'
gem 'sass-rails', '~> 5.0'
gem 'simple_form'
gem 'slim-rails'

# Search tools
gem 'google_custom_search_api'
gem 'httparty'

# natural language processing
gem 'pragmatic_segmenter'
gem 'treetop'

group :production, :staging do
  # Garbage collection tuning
  gem 'tunemygc'
end

group :test do
  gem 'database_cleaner'
  gem 'fakeredis'
  gem 'rails-controller-testing'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'awesome_print'
  gem 'byebug', '~> 9', platform: :mri
  gem 'coveralls', require: false
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'fuubar'
  gem 'rerun'
  gem 'rspec-rails'
  gem 'ruby-prof', '>= 0.17.0', require: false
  gem 'vcr'
  gem 'webmock'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %>
  #   anywhere in the code.
  gem 'guard-rspec'
  gem 'listen', '~> 3.0.5'
  gem 'pry-rails'
  # Spring speeds up development by keeping your application running
  # in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring', '< 2.1'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
