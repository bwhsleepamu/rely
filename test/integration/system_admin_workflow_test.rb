require 'test_helper'

SimpleCov.command_name "test:integration"

class SystemAdminWorkflowTest < ActionDispatch::IntegrationTest
  def setup
    @user = login_admin
  end

  test "should get list of all exercises" do
    visit exercises_path
    print Exercise.all.count
    assert_equal true, page.has_selector?("tbody tr", :count => Exercise.all.count)
  end
end
