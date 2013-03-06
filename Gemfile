source 'https://rubygems.org'

gem 'rails',                '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem "uuid",                 '~> 2.3.5'

# Windows
gem 'thin',                 '~> 1.5.0',           :platforms => [ :mswin, :mingw ]
gem 'eventmachine',         '~> 1.0.0',           :platforms => [ :mswin, :mingw ]

# Contour
gem 'contour',              '~> 1.2.0'
gem 'kaminari',             '~> 0.14.1'
gem 'ruby-ntlm-namespace', '~> 0.0.1'

# File Upload/Download
gem "paperclip", "~> 3.1"
gem 'rubyzip'
gem 'zippy'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.0.1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',         '~> 3.2.5'
  gem 'coffee-rails',       '~> 3.2.2'
  gem 'uglifier',           '>= 1.0.3'
end

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
  gem 'simplecov',          '~> 0.7.1',           :require => false
  gem 'database_cleaner'
  gem 'capybara'
  gem 'poltergeist'
  gem "factory_girl_rails" #, '~> 3.0'
end

