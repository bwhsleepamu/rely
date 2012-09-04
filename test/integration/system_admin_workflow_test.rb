require 'test_helper'

SimpleCov.command_name "test:integration"

class SystemAdminWorkflowTest < ActionDispatch::IntegrationTest
  def setup
    @user = login_admin
  end

  ##
  # Exercises

  test "should get list of all exercises" do
    exercises = create_list(:exercise, 3, admin_id: @user.id)

    visit exercises_path
    assert find("tbody").has_selector?("tr", :count => Exercise.current.count)
  end

  test "should see completion status (user that completed) of exercises and date of completion" do
    exercises = create_list(:exercise, 3, admin_id: @user.id)
    my_exercise = exercises.first

    visit exercises_path
    show_page

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
      create(:result, reliability_id_id: r_id.id)
    end

    visit exercises_path

    my_exercise.reload

    tr = find("tr##{my_exercise.id}")
    assert tr.find("td.status").has_content?("#{my_exercise.percent_completed}%")
    assert_not_nil my_exercise.completed_at
    assert tr.find("td.completed_at").has_content?("Today at #{my_exercise.completed_at.strftime("%I:%M %p")}")

    click_on my_exercise.name

    finished = find("#finished_scorers")

    my_exercise.finished_scorers.each do |scorer|
      finished.has_content?(scorer.name)
    end

    show_page
  end

  test "should be able to get results for completed exercise" do
    exercises = create_list(:exercise, 3, admin_id: @user.id)
    my_exercise = exercises.first

    visit exercise_path(my_exercise)


    my_exercise.reliability_ids.each do |r_id|
      create(:result, reliability_id_id: r_id.id)
    end

    visit current_path


  end

  test "should be able to launch an exercise" do
    #pending "fails on travis ci - debug please"
    # Setup
    users = create_list(:user, 10)
    groups = create_list(:group_with_studies, 4)
    rule = create(:rule)
    name = "Test Exercise"
    assessment_type = Assessment::TYPES[:paradox]
    description = "Description for a very vital exercise."
    reset_email

    # Creation
    visit exercises_path
    click_on "Create Exercise"


    fill_in "Name", :with => name
    fill_in "Description", :with => description
    select_from_chosen assessment_type[:title], :from => "Assessment Type"
    select_from_chosen rule.name, :from => "Rule"
    groups.each do |group|
      select_from_chosen group.name, :from => "Groups"
    end
    users.each do |user|
      select_from_chosen user.name, :from => "Scorers"
    end

    click_button "Launch Exercise"

    # Show Page
    assert has_content?("Exercise was successfully launched."), page.html
    assert has_content?(@user.name)
    assert has_content?("Assigned")
    assert has_content?("Completed")
    assert has_content?(name)
    assert has_content?(description)
    groups.each do |group|
      assert has_content?(group.name)
    end
    users.each do |user|
      assert has_content?(user.name)
    end
    assert has_content?(rule.title)

    # Emails Sent
    assert_equal users.count, email_count
    recipients = email_recipients
    users.each do |user|
      assert recipients.include?(user.email)
    end
  end

  ##
  # Studies

  test "should be able to create a group of studies" do
    study_count = 20
    group_name = "Test Group"
    description = "This is a description of group that consists of many studies."
    study_indexes = [0, 2, 4, 8, 11, 13, 19]

    studies = setup_for_group_creation(study_count)
    visit groups_path
    click_on "Create Group"
    fill_in 'Name', :with => group_name
    fill_in 'Description', :with => description
    assert find("#group_study_ids").has_selector?("option", :count => study_count), "Available studies are not all shown in select."

    study_indexes.each do |i|
      select_from_chosen studies[i].long_name, :from => "Studies"
    end
    click_button "Create Group"

    assert has_content?("Group was successfully created.")
    assert has_content?(group_name), "No group name displayed."
    assert has_content?(description), "No description displayed"

    study_indexes.each do |i|
      assert has_content?(studies[i].to_s)
    end
  end

  test "should be able to create a study type" do
    study_type_name = "Test Study Type"
    description = "Study type description is here."

    visit study_types_path
    click_on "Create Study Type"
    fill_in "Name", :with => study_type_name
    fill_in "Description", :with => description
    assert has_no_content?('Deleted'), 'Deleted flag should not show up'

    click_button "Create Study Type"

    assert has_content?("Study type was successfully created."), "No success message shown."
    assert has_content?(study_type_name), "No study type name shown"
    assert has_content?(description), "No study type description shown"
  end

  test "should be able to create study" do
    study_type = create(:study_type)
    study_id = "OIDSTUDY1"
    study_location = "/path/to/somewhere/cool/"

    visit studies_path
    click_on "Create Study"
    fill_in "Original ID", :with => study_id
    fill_in "Location", :with => study_location
    select_from_chosen study_type.name, :from => "Study Type"

    click_button "Create Study"

    assert has_content?("Study was successfully created.")
    assert has_content?(study_type.name)
    assert has_content?(study_id)
    assert has_content?(study_location)
  end

  test "should be able to create rule" do
    title = "Test Rule"
    procedure = "Test rule procedure for how to score these things."

    visit rules_path
    click_on "Create Rule"
    fill_in "Title", :with => title
    fill_in "Procedure", :with => procedure

    click_button "Create Rule"

    assert has_content?("Rule was successfully created.")
    assert has_content?(title)
    assert has_content?(procedure)
  end

  test "should be able to create project" do
    name = "Test Project"
    description = "Test project description is here and very very interesting."
    start_date = DateTime.now()
    end_date = start_date + 2.months
    group_count = 4
    groups = create_list(:group_with_studies, group_count)

    visit projects_path
    click_on "Create Project"

    fill_in "Start Date", :with => start_date.strftime("%m/%d/%Y")
    fill_in "End Date", :with => end_date.strftime("%m/%d/%Y")
    page.execute_script('$("#ui-datepicker-div").hide()')
    fill_in "Name", :with => name
    fill_in "Description", :with => description

    assert_equal group_count, groups.count

    groups.each do |group|
      select_from_chosen group.name, :from => "Groups"
    end

    assert has_no_content?('Deleted'), 'Deleted flag should not show up'

    click_button "Create Project"

    assert has_content?("Project was successfully created.")
    assert has_content?(name)
    assert has_content?(description)
    assert has_content?(start_date.strftime("%Y-%m-%d"))
    assert has_content?(end_date.strftime("%Y-%m-%d"))

    groups.each do |group|
      assert has_content?(group.name)
    end

  end


  private

  def setup_for_group_creation(study_count)
    study_type = create(:study_type)
    create_list(:study, study_count, study_type: study_type)
  end

end
