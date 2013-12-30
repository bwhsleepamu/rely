source 'https://rubygems.org'

gem 'rails',                '4.0.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg',                   '~> 0.15.1'
gem "uuid",                 '~> 2.3.5'

# Windows
gem 'thin',                 '~> 1.5.0',           :platforms => [ :mswin, :mingw ]
gem 'eventmachine',         '~> 1.0.0',           :platforms => [ :mswin, :mingw ]

# Contour
gem 'contour',              '~> 2.2.0'
gem 'kaminari',             '~> 0.14.1'
gem 'ruby-ntlm-namespace',  '~> 0.0.1'

# File Upload/Download
gem "paperclip", "~> 3.1"
gem 'rubyzip', ">= 1.0.0"


# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Rails Defaults
gem 'coffee-rails',         '~> 4.0.0'
gem 'sass-rails',           '~> 4.0.0'
gem 'uglifier',             '>= 1.3.0'

gem 'jbuilder',             '~> 1.4'
gem 'jquery-rails'
gem 'jquery-fileupload-rails'

# Diagrams
group :development, :test do
  gem 'railroady', :platforms => :ruby
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

# Testing
group :test do
  # Pretty printed test output
  gem 'win32console',                             :platforms => [ :mswin, :mingw ]
  gem 'turn',               '~> 0.9.6'
  gem 'simplecov', :require => false
  gem 'database_cleaner'
  gem 'capybara'
  gem 'poltergeist'
  gem "factory_girl_rails" #, '~> 3.0'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

