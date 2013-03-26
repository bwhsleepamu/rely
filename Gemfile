source 'https://rubygems.org'

gem 'rails',                '4.0.0.beta1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem "uuid",                 '~> 2.3.5'

# Windows
gem 'thin',                 '~> 1.5.0',           :platforms => [ :mswin, :mingw ]
gem 'eventmachine',         '~> 1.0.0',           :platforms => [ :mswin, :mingw ]

# Contour
gem 'contour',              '2.0.0.beta.4'
gem 'devise',               '~> 2.2.3',           github: 'plataformatec/devise', ref: 'd29b744'   # , branch: 'rails4'
gem 'kaminari',             '~> 0.14.1'
gem 'ruby-ntlm-namespace', '~> 0.0.1'

# File Upload/Download
gem "paperclip", "~> 3.1"
gem 'rubyzip'


# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.0.2'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',         '~> 4.0.0.beta1'
  gem 'coffee-rails',       '~> 4.0.0.beta1'
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

