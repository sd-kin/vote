# frozen_string_literal: true
ruby '2.3.0'
source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# use postgres as bd adapter
gem 'pg'
# use vote-schulze for schulze algorithm
gem 'vote-schulze'
# use rollbar to catch errors on rollbar.com
gem 'rollbar'
# use oj for JSON serialization
gem 'oj'
# use jquery ui to interact with frontend elements
gem 'jquery-ui-rails'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug'
  # use rspec for tests
  gem 'rspec-rails'
  # use guard for automate tests
  gem 'guard'
  # use Rubocop to fix code style
  gem 'rubocop'
  # use guard-rubocop to run rubocop automatically
  gem 'guard-rubocop'
  # use capypara for acceptanse tests
  gem 'capybara'
  # use capybara-webkit for test ajax requests
  gem 'poltergeist'
  # use haml preprocessor for accurate views
  gem 'haml'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :test do
  # generators instead of fixtures
  gem 'factory_girl_rails', :require => false
  gem 'database_cleaner'
  gem 'rspec_junit_formatter', '0.2.2'
end

group :production do
  # use 12factor for easier running rails app
  gem 'rails_12factor'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
