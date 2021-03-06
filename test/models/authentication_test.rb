require 'test_helper'

SimpleCov.command_name "test:units"

class AuthenticationTest < ActiveSupport::TestCase
  fixtures :all

  test "should get provider name and handle OpenID special case" do
    assert_equal 'OpenID', authentications(:open_id).provider_name
  end

  test "should get provider name" do
    assert_equal 'Google Apps', authentications(:google_apps).provider_name
  end
end
