require 'test_helper'

SimpleCov.command_name "test:integration"

class ProjectWorkflowTest < ActionDispatch::IntegrationTest
  def setup
    @user = login_user
  end

  test "should display projects viewable to users"
end