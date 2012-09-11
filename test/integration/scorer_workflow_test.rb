require 'test_helper'

SimpleCov.command_name "test:integration"

class ScorerWorkflowTest < ActionDispatch::IntegrationTest
  def setup
    @user = login_user
  end

  test "Scorer is directed to Exercise page on login." do
    assert_equal true, page.has_content?("Exercises")
  end

  test "Scorer can search on exercise name or description" do
    exercises = setup_exercises
    visit exercises_path
    fill_in "search", :with => exercises[:seen].first.name
    click_on "Search"

    assert page.has_selector?("#exercise_table tbody tr", :count => 1)
    assert page.has_content?(exercises[:seen].first.name)

    e = exercises[:seen].last
    e.description = "some description of the exercise for searching reasons"
    e.save
    fill_in "search", :with => "searching reasons"
    click_on "Search"

    assert page.has_selector?("#exercise_table tbody tr", :count => 1)
    assert page.has_content? "some description of the exercise for searching reasons"
  end

  test "Scorer can search on rule title or procedure" do
    rules = create_list(:rule, 5)
    visit rules_path

    fill_in "search", :with => rules[0].name
    click_on "Search"

    assert page.has_selector?("tbody tr", :count => 1)
    assert page.has_content?(rules[0].name)
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

    assert (exercise.all_studies.count > 0)
    assert page.has_content?("Dashboard for Exercise #{exercise.name}")
    assert page.has_selector?("tr.study", :count => exercise.all_studies.count)
    assert page.has_content?("Scored?")

    exercise.reliability_ids.where(:user_id => @user.id).each do |r_id|
      assert_not_nil r_id
      show_page
      assert page.has_content?(r_id.unique_id), "Page does not include #{r_id.unique_id}"
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
    r_id = ReliabilityId.find_by_unique_id(tr.find("td.reliability_id").text)
    study = r_id.study
    tr.click_link("Add Result")

    assert page.has_content? study.location
    assert page.has_content?(study.study_type.name)

    assert page.has_content?("Result for Study #{r_id.unique_id}")
    assert_equal new_result_path, current_path

    fill_in "Location", :with => "/some/location/to/result/file"
    fill_in "Result type", :with => "Some Type of Result"
    fill_in "result_assessment_answers_1", :with => "233"
    select_from_chosen "Some", :from => "result_assessment_answers_2"
    show_page
    click_on "Add Result"

    tr = all("tr.study").first

    assert tr.has_content? "true"
    tr.click_on "Edit Result"

    assert_equal 233.to_s, find_field("result_assessment_answers_1").value
  end

  test "Scorer can complete an exercise" do
    exercises = setup_exercises
    exercise = exercises[:seen].second

    visit exercises_path

    tr = find("tr##{exercise.id}")
    assert tr.find("td.completed").has_content?("no")

    # Add results
    exercise.reliability_ids.where(:user_id => @user.id).each do |r_id|
      create(:result, reliability_id_id: r_id.id)
    end

    visit(current_path)

    tr = find("##{exercise.id}")
    assert tr.find("td.completed").has_content?("yes")
    show_page
  end

  test "Scorer can edit a result for a study in an exercise" do
    exercises = setup_exercises
    exercise = exercises[:seen].first
    r_id = @user.exercise_reliability_ids(exercise).first
    result = create(:result, reliability_id_id: r_id.id)

    new_location = "new/location/after/edit"
    new_answer_1 = "100001"
    new_answer_2 = "A lot"

    visit(edit_result_path(result))


    assert_equal result.location, page.find_field("Location").value
    assert_equal 2, result.assessment.assessment_results.length

    result.assessment.assessment_results.each_with_index do |assessment_result, i|
      assert_equal assessment_result.answer, page.find("#result_assessment_answers_#{i+1}").value
    end



    fill_in "Location", :with => new_location
    fill_in "result_assessment_answers_1", :with => new_answer_1
    select_from_chosen new_answer_2, :from => "result_assessment_answers_2"


    click_on "Update Result"
    visit(edit_result_path(result))

    show_page

    assert_equal new_location, page.find_field("Location").value
    assert_equal new_answer_1, page.find("#result_assessment_answers_1").value
    assert_equal "3", page.find("#result_assessment_answers_2").value

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
