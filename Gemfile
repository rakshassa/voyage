source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# See https://github.com/rails/execjs#readme for more supported runtimes
# duktape makes nodejs NOT work - causing execjs runtime errors.
# comment out duktape and execjs, install nodejs and have it in the path.
# gem 'duktape'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# Updated coffee-script-source doesn't work on windows 10 with rails 5.
gem 'coffee-script-source', '1.8.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# password encryption and salting
gem 'bcrypt-ruby', :require => 'bcrypt'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
# read and validate ENV variables
gem 'envied'
# great fonts
gem "font-awesome-rails"

gem "omniauth-google-oauth2", '~> 0.5.3'
gem 'omniauth-facebook', '~> 5.0.0'
gem 'omniauth-discord', '~> 0.1.8'
gem 'omniauth-twitter', '~> 1.4.0'
gem 'activerecord-session_store'

gem 'bootstrap', '~> 4.1.3'
gem 'jquery-rails'

gem 'will_paginate'
gem 'will_paginate-bootstrap'

# might need this line before first call: Aws.use_bundled_cert!
gem 'aws-sdk-rails'
gem 'aws-sdk-s3'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
