require 'simplecov'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'support/mailer_macros'

Capybara.javascript_driver = :poltergeist # :selenium
Capybara.default_driver = :poltergeist # :selenium

# Transactional fixtures do not work with Selenium tests, because Capybara
# uses a separate server thread, which the transactions would be hidden
# from. We hence use DatabaseCleaner to truncate our test database.
DatabaseCleaner.strategy = :truncation

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting

  ## Moved to ActionController::TestCase and ActionMailer::TestCase to exclude from Integration Tests
  #fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionMailer::TestCase
  fixtures :all
end

class ActionController::TestCase
  include Devise::TestHelpers

  fixtures :all

  def login(resource)
    @request.env["devise.mapping"] = Devise.mappings[resource]
    sign_in(resource.class.name.downcase.to_sym, resource)
  end
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  include FactoryGirl::Syntax::Methods
  include MailerMacros

  # Stop ActiveRecord from wrapping tests in transactions
  self.use_transactional_fixtures = false

  Capybara.current_driver = Capybara.javascript_driver

  teardown do
    DatabaseCleaner.clean       # Truncate the database
    Capybara.reset_sessions!    # Forget the (simulated) browser state
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
  end

  def sign_in_as(user_template, password, email)
    user = User.create(password: password, password_confirmation: password, email: email,
                       first_name: user_template.first_name, last_name: user_template.last_name)
    user.update_attribute :status, user_template.status
    user.update_attribute :deleted, user_template.deleted?
    user.update_attribute :system_admin, user_template.system_admin?

    post_via_redirect 'users/login', user: { email: email, password: password }

    user
  end

  def show_page
    page.driver.render('/home/pwm4/Documents/page.png', :full => true)
  end

  def login_user(user = nil)
    password = "secret"
    user ||= create(:user, password: password)
    user.password = password
    user.save

    visit new_user_session_path
    show_page
    fill_in('Email', :with => user.email)
    fill_in('Password', :with => password)
    click_button("Sign in")

    user
  end

  #def login_admin
  #  password = "secret"
  #  user = create(:admin, password: password)
  #  visit new_user_session_path
  #  fill_in('Email', :with => user.email)
  #  fill_in('Password', :with => password)
  #  click_button("Sign in")
  #
  #  user
  #end

  def select_from_chosen(item_text, options)
    field = find_field(options[:from], {visible: false})
    option_value = page.evaluate_script("$(\"##{field[:id]} option:contains('#{item_text}')\").val()")
    page.execute_script("value = ['#{option_value}']\; if ($('##{field[:id]}').val()) {$.merge(value, $('##{field[:id]}').val())}")
    option_value = page.evaluate_script("value")
    page.execute_script("$('##{field[:id]}').val(#{option_value})")
    page.execute_script("$('##{field[:id]}').trigger('liszt:updated').trigger('change')")
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
