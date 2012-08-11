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

  test "Scorer can view exercise and see a list of studies with uuids and statuses." do
    exercises = setup_exercises
    exercise = exercises[:seen].first

    visit exercises_path

    click_on exercise.name
    show_page
    assert page.has_content?("Dashboard for Exercise #{exercise.name}")
    assert page.has_selector?("tbody.group", :count => exercise.groups.count)
    assert page.has_selector?("tr.study", :count => exercise.groups.inject(0){|sum, group| sum + group.studies.count } )
    assert page.has_content?("Scored?")

    exercise.groups.each do |group|
      group.studies.each do |study|
        r_id = study.reliability_id(@user, exercise)
        assert_not_nil r_id
        assert page.has_content?(r_id.unique_id)
      end
    end
  end

  test "Scorer can visit rule page from exercise page" do
    exercises = setup_exercises
    exercise = exercises[:seen].first

    visit exercises_path
    click_on exercise.name

    click_on exercise.rule.title

    assert_equal rule_path(exercise.rule), current_path
    assert page.has_content? exercise.rule.procedure
  end

  test "Scorer can attach results to studies in an exercise." do
    exercises = setup_exercises
    exercise = exercises[:seen].first

    visit exercises_path
    click_on exercise.name

    study_count = 0
    all("tr.study").each do |tr|
      study = Study.find_by_reliability_id(tr.find("td.reliability_id").text)
      tr.click_link("Add Result")
      show_page
      assert page.has_content? study.location
      assert_equal page.has_content? study.original_id
      assert_equal new_result_path, current_path
      assert page.has_content?("Add Result for Study #{study.reliability_id(@user, exercise)} in Exercise #{exercise.name}")
      fill_in "Location", :with => "/some/location/to/result/file"
      fill_in "Result Type", :with => "Some Type of Result"
      click_on "Add Result"
      tr.has_content? "true"
      tr.has_content? "Edit Result"
      study_count += 1
    end

    assert_equal study_count, exercise.all_studies.count
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
