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
    exercises = setup_exercises

    visit exercises_path

    assert page.has_selector?("#exercise_table tbody tr", :count => exercises[:seen].count)
    exercises[:seen].each do |se|
      assert page.has_content?(se.name)
    end
    #exercises[:unseen].each
  end

  test "Scorer can view exercise, get study, and upload result." do
    exercises = setup_exercises
    exercise = exercises[:seen].first

    visit exercises_path

    click_on exercise.name
    show_page
    assert page.has_content?("Dashboard for Exercise #{exercise.name}")
    assert page.has_selector?("tbody.group", :count => exercise.groups.count)
    assert page.has_selector?("tr.study", :count => exercise.groups.inject(0){|sum, group| sum + group.studies.count } )

    exercise.groups.each do |group|
      group.studies.each do |study|
        r_id = study.reliability_id(@user, exercise)
        assert_not_nil r_id
        assert page.has_content?(r_id.unique_id)
      end
    end
  end

  private

  def setup_exercises
    unseen_exercises = create_list :exercise, 2
    scorer_exercises = create_list :exercise, 3

    scorer_exercises.each do |e|
      e.scorers << @user
      e.save
    end
    {:unseen => unseen_exercises, :seen => scorer_exercises}
  end
end
