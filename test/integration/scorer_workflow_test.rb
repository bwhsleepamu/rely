require 'test_helper'

SimpleCov.command_name "test:integration"

class ScorerWorkflowTest < ActionDispatch::IntegrationTest
  def setup
    @user = login_user
  end

  test "Scorer is directed to Exercise page on login." do
    assert_equal true, page.has_content?("Exercises")
  end

  test "Scorer sees assigned exercises on Exercise page." do
    unseen_exercises = create_list :exercise, 10
    scorer_exercises = create_list :exercise, 5

    scorer_exercises.each do |e|
      e.users << @user
      e.save
    end

    visit exercises_path

    show_page



  end

  test "Scorer can view exercise, get study, and upload result." do
    visit exercises_path
  end

end
