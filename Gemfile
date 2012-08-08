source 'https://rubygems.org'

gem 'rails', '3.2.6'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem "uuid", "~> 2.3.5"

# Windows
gem 'thin',                 '~> 1.3.1',           :platforms => [ :mswin, :mingw ]
gem 'eventmachine',         '~> 1.0.0.beta.4.1',  :platforms => [ :mswin, :mingw ]


# Contour
gem 'contour', '~> 1.0.1'
gem 'kaminari', '~> 0.13.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'chosen-rails'
end

gem 'jquery-rails'

# Testing
group :test do
  # Pretty printed test output
  gem 'win32console',                             :platforms => [ :mswin, :mingw ]
  gem 'turn',               '~> 0.9.5'
  gem 'simplecov',          '~> 0.6.4',           :require => false
  gem 'database_cleaner'
  gem 'capybara'
  gem 'poltergeist'
  gem "factory_girl_rails", "~> 3.0"
end

