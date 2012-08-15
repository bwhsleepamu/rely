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

  test "Scorer can attach a result to a study in an exercise." do
    exercises = setup_exercises
    exercise = exercises[:seen].first

    visit exercises_path
    click_on exercise.name

    tr = all("tr.study").first
    study = Study.find_by_reliability_id(tr.find("td.reliability_id").text)
    tr.click_link("Add Result")
    show_page
    assert page.has_content? study.location
    assert page.has_content?(study.study_type.name)

    assert page.has_content?("Result for Study #{study.reliability_id(@user, exercise).unique_id}")
    assert_equal new_result_path, current_path

    fill_in "Location", :with => "/some/location/to/result/file"
    fill_in "Result type", :with => "Some Type of Result"
    fill_in "result_assessment_answers_1", :with => "233"
    select "Some", :from => "result_assessment_answers_2"

    click_on "Add Result"
    show_page
    tr = all("tr.study").first
    tr.has_content? "true"
    tr.click_on "Edit Result"

    show_page
    assert_equal 233.to_s, find_field("result_assessment_answers_1").value
  end

  test "Scorer can edit a result for a study in an exercise" do
    pending "finish above first"
    exercises = setup_exercises
    exercise = exercises[:seen].first
    study = exercise.all_studies.first
    result = create(:result, user_id: @user.id, exercise_id: exercise.id, rule_id: exercise.rule.id, study_id: study.id )
    assessment_


    visit exercise_path(exercise)

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
