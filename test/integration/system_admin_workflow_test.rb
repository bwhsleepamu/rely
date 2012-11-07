require 'test_helper'

SimpleCov.command_name "test:integration"

class SystemAdminWorkflowTest < ActionDispatch::IntegrationTest
  def setup
    @user = login_admin
  end

  ##
  # Exercises

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
    assessment_type = Assessment::TYPES[:paradox]

    visit rules_path
    click_on "Create Rule"
    fill_in "Title", :with => title
    fill_in "Procedure", :with => procedure
    select_from_chosen assessment_type[:title], :from => "Assessment Type"

    click_button "Create Rule"

    show_page
    assert has_content?("Rule was successfully created.")
    assert has_content?(title)
    assert has_content?(procedure)
    assert has_content?("paradox")
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

  test "should be able to add and update original results in study edit screen" do
    study = create(:study)
    rule1 = create(:rule)
    rule2 = create(:rule)

    location = "/my/test/location/here/it/is"

    visit edit_study_path(study)

    assert page.has_no_selector?("#original_results .well")

    select_from_chosen rule1.title, :from => "rule_id"
    click_on "Add New Original Result"


    assert page.has_selector?("#original_results .well")


    result_form = page.find(".well")

    assert result_form.has_content? rule1.title

    result_form.fill_in "result_location", :with => location
    result_form.fill_in "study_results__assessment_answers_1", :with => "233"
    select_from_chosen "Some", :from => "study_results__assessment_answers_2"

    click_on "Update Study"

    visit edit_study_path(study)

    assert page.has_selector?("#original_results .well", :count => 1)
    assert page.has_content? rule1.title
    assert_equal location, find("#result_location").value



    select_from_chosen rule2.title, :from => "rule_id"
    click_on "Add New Original Result"

    assert page.has_selector?(".well", :count => 2)

    page.find(".well").click_on("delete")

    result_form = page.find(".well")
    result_form.fill_in "result_location", :with => location
    result_form.fill_in "study_results__assessment_answers_1", :with => "2333"


    click_on "Update Study"

    visit edit_study_path(study)
    assert page.has_selector?(".well", :count => 1)
  end






  private

  def setup_for_group_creation(study_count)
    study_type = create(:study_type)
    create_list(:study, study_count, study_type: study_type)
  end

end
