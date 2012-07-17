require 'simplecov'
require 'capybara/rails'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# Transactional fixtures do not work with Selenium tests, because Capybara
# uses a separate server thread, which the transactions would be hidden
# from. We hence use DatabaseCleaner to truncate our test database.
DatabaseCleaner.strategy = :truncation

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::TestHelpers

  def login(resource)
    @request.env["devise.mapping"] = Devise.mappings[resource]
    sign_in(resource.class.name.downcase.to_sym, resource)
  end
end

class ActionController::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  # Stop ActiveRecord from wrapping tests in transactions
  self.use_transactional_fixtures = false

  teardown do
    DatabaseCleaner.clean       # Truncate the database
    Capybara.reset_sessions!    # Forget the (simulated) browser state
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
  end

  def sign_in_as(user_template, password, email)
    user = User.create(password: password, password_confirmation: password, email: email,
                       first_name: user_template.first_name, last_name: user_template.last_name)
    user.save!
    user.update_attribute :status, user_template.status
    user.update_attribute :deleted, user_template.deleted?
    user.update_attribute :system_admin, user_template.system_admin?
    post_via_redirect 'users/login', user: { email: email, password: password }
    user
  end
end

module Rack
  module Test
    class UploadedFile
      def tempfile
        @tempfile
      end
    end
  end
end
