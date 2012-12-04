require 'test_helper'

SimpleCov.command_name "test:integration"

class ExerciseWorkflowTest < ActionDispatch::IntegrationTest
  def setup
    @managed_project = create :project
    @assigned_project = create :project
    @user = @managed_project.managers.first
    @assigned_project.scorers << @user

    login_user(@user)
  end

  test "should show managed exercises and assigned exercises" do
    # Setup
    other_exercises = create_list :exercise, 3
    managed_exercises = create_list :exercise, 3, existing_project_id: @managed_project.id
    assigned_exercises = create_list :exercise, 2, existing_project_id: @assigned_project.id
    assigned_exercises.each do |ae|
      ae.scorers << @user unless ae.scorers.include? @user
      ae.save
    end

    # Test
    visit exercises_path
    assert find("#managed_exercises tbody").has_selector?("tr", :count => @user.all_exercises.count)
    assert find("#assigned_exercises tbody").has_selector?("tr", :count => @user.assigned_exercises.count)
  end

  test "should see completion status (scorers who completed a given exercise) of managed exercises and their date of completion" do
    exercises = create_list :exercise, 3, existing_project_id: @managed_project.id
    my_exercise = exercises.first

    visit exercises_path

    exercises.each do |exercise|
      tr = find("tr##{exercise.id}")
      assert tr.find("td.status").has_content?("0%")
    end

    click_on my_exercise.name

    assert page.has_content?("Finished Scorers")
    assert page.has_content?("Pending Scorers")

    pending = find("#pending_scorers")

    my_exercise.pending_scorers.each do |scorer|
      pending.has_content?(scorer.name)
    end

    my_exercise.reliability_ids.each do |r_id|
      r_id.result = create(:result)
      r_id.save
      my_exercise.check_completion
    end

    visit exercises_path

    my_exercise.reload

    tr = find("tr##{my_exercise.id}")
    assert tr.find("td.status").has_content?("#{"%.1f" % my_exercise.percent_completed}%")
    assert_not_nil my_exercise.completed_at
    assert tr.find("td.completed_at").has_content?("Today at #{my_exercise.completed_at.strftime("%I:%M %p")}")

    click_on my_exercise.name

    finished = find("#finished_scorers")

    my_exercise.finished_scorers.each do |scorer|
      finished.has_content?(scorer.name)
    end


  end

  test "should be able to get rescored results and original results for managed exercises" do
    exercises = create_list(:exercise, 3, existing_project_id: @managed_project)
    my_exercise = exercises.first
    orig_results = []
    visit exercise_path(my_exercise)


    results = page.find("#results")

    my_exercise.all_studies.each do |study|
      assert results.has_content?(study.name)
      assert results.has_content?(study.original_id)
      new_orig_result = create(:result)

      study.study_original_results.create(study_id: study.id, result_id: new_orig_result.id, rule_id: my_exercise.rule.id)
      orig_results << new_orig_result
    end

    my_exercise.reliability_ids do |reliability_id|
      assert results.has_content?(reliability_id.unique_id)
      assert results.has_content?(reliability_id.user.name)
    end

    visit exercise_path(my_exercise)

    select('All', :from => 'DataTables_Table_0_length')

    results = page.find("#results")

    orig_results.each do |r|
      assert results.has_content?(r.location.to_s)
    end
  end

  test "should be able to launch an exercise" do
    # Setup
    name = "Test Exercise"
    description = "Description for a very vital exercise."
    reset_email

    # Creation
    visit exercises_path
    click_on "Create Exercise"

    select_from_chosen @managed_project.name, :from => "Project"

    page.find("form")
    select_from_chosen @managed_project.rules.first.name, :from => "Rule"
    @managed_project.groups.each do |group|
      select_from_chosen group.name, :from => "Groups"
    end
    @managed_project.scorers.each do |scorer|
      select_from_chosen scorer.name, :from => "Scorers"
    end
    fill_in "Name", :with => name
    fill_in "Description", :with => description

    click_button "Launch Exercise"


    select('All', :from => 'DataTables_Table_0_length')


    # Show Page
    assert has_content?("Exercise was successfully launched."), page.html
    assert has_content?("Assigned")
    assert has_content?("Completed")
    assert has_content?(name)
    assert has_content?(description)

    assert has_content?("#{@managed_project.studies.length * (@managed_project.scorers.length + 1)} entries")# , "#{@managed_project.studies.length} Entries"

    @managed_project.scorers.each do |user|
      assert has_content?(user.name)
    end

    assert has_content?( @managed_project.rules.first.title)

    # Emails Sent
    assert_equal @managed_project.scorers.count, email_count
    recipients = email_recipients
    @managed_project.scorers.each do |user|
      assert recipients.include?(user.email)
    end
  end

  test "should be able to search on exercise name or description" do
    pending
    #exercises = setup_exercises
    #visit exercises_path
    #fill_in "search", :with => exercises[:seen].first.name
    #click_on "Search"
    #
    #assert page.has_selector?("#exercise_table tbody tr", :count => 1)
    #assert page.has_content?(exercises[:seen].first.name)
    #
    #e = exercises[:seen].last
    #e.description = "some description of the exercise for searching reasons"
    #e.save
    #fill_in "search", :with => "searching reasons"
    #click_on "Search"
    #
    #assert page.has_selector?("#exercise_table tbody tr", :count => 1)
    #assert page.has_content? "some description of the exercise for searching reasons"
  end

  ##
  # Scorer Functionality
  test "Scorer can view exercise and see a list of studies with uuids and statuses." do
    assigned_exercises = create_list :exercise, 2, existing_project_id: @assigned_project.id
    assigned_exercises.each do |ae|
      ae.scorers << @user unless ae.scorers.include? @user
      ae.save
    end
    exercise = assigned_exercises.first

    visit exercises_path
    click_on exercise.name

    assert (exercise.all_studies.count > 0)
    assert page.has_content?("Dashboard for Exercise #{exercise.name}")
    assert page.has_selector?("tr.study", :count => exercise.all_studies.count)
    assert page.has_content?("Scored?")

    exercise.reliability_ids.where(:user_id => @user.id).each do |r_id|
      assert_not_nil r_id
      assert page.has_content?(r_id.unique_id), "Page does not include #{r_id.unique_id}"
    end
  end

  test "Scorer can attach a result to a study in an exercise." do
    assigned_exercises = create_list :exercise, 2, existing_project_id: @assigned_project.id
    assigned_exercises.each do |ae|
      ae.scorers << @user unless ae.scorers.include? @user
      ae.save
    end
    exercise = assigned_exercises.first

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
    fill_in "result_assessment_answers_1", :with => "233"
    select_from_chosen "Some", :from => "result_assessment_answers_2"

    click_on "Add Result"

    tr = all("tr.study").last

    assert tr.has_content? "true"
    tr.click_on "Edit Result"

    assert_equal 233.to_s, find_field("result_assessment_answers_1").value
  end

  test "Scorer can complete an exercise" do
    assigned_exercises = create_list :exercise, 2, existing_project_id: @assigned_project.id
    assigned_exercises.each do |ae|
      ae.scorers << @user unless ae.scorers.include? @user
      ae.save
    end
    exercise = assigned_exercises.first

    visit exercises_path

    tr = find("tr##{exercise.id}")
    assert tr.find("td.completed").has_content?("no")

    # Add results
    exercise.reliability_ids.where(:user_id => @user.id).each do |r_id|
      r_id.result = create(:result)
      r_id.save
    end

    visit(current_path)

    tr = find("##{exercise.id}")
    assert tr.find("td.completed").has_content?("yes")
    show_page
  end

  test "Scorer can edit a result for a study in an exercise" do
    assigned_exercises = create_list :exercise, 2, existing_project_id: @assigned_project.id
    assigned_exercises.each do |ae|
      ae.scorers << @user unless ae.scorers.include? @user
      ae.save
    end
    exercise = assigned_exercises.first
    r_id = @user.exercise_reliability_ids(exercise).first
    result = create(:result)
    r_id.result = result
    r_id.save

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


end
