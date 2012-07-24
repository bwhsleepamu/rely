require 'test_helper'

SimpleCov.command_name "test:integration"

class ScorerWorkflowTest < ActionDispatch::IntegrationTest
  def setup

    @user = login_user
  end

  test "Scorer is directed to Exercise page on login." do
    assert_equal true, page.has_content?("Exercises")
  end

  test "Scorer sees assigned exercises with statuses on Exercise page." do
    visit exercises_path

  end

  test "Scorer can view exercise, get study, and upload result." do
    visit exercises_path
  end

end
