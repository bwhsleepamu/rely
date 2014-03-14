require 'test_helper'
SimpleCov.command_name "test:integration"

class StudyWorkflowTest < ActionDispatch::IntegrationTest
  def setup
    @project = create :project
    @user = @project.managers.first
    login_user(@user)
  end

  test "should be able to create study" do
    study_id = "OIDSTUDY1"
    study_location = "/path/to/somewhere/cool/"
    study_type = @project.study_types.first

    visit studies_path

    click_on "Create Study"

    select_from_chosen @project.name, :from => "Project"

    fill_in "Original ID", :with => study_id
    fill_in "Location", :with => study_location
    select_from_chosen study_type.name, :from => "Study Type"

    click_button "Create Study"

    assert has_content?("Study was successfully created.")
    assert has_content?(study_type.name)
    assert has_content?(study_id)
    assert has_content?(study_location)
  end

  test "should be able to add and update original results in study edit screen" do
    study = @project.studies.first
    rule1 = @project.rules.first
    rule2 = @project.rules.last

    location = "/my/test/location/here/it/is"

    visit edit_study_path(study)

    assert page.has_no_selector?("#original_results .well")

    select_from_chosen rule1.title, :from => "rule_id"
    click_on "Add New Original Result"



    assert page.has_selector?("#original_results .well")

    result_form = page.find(".well")

    assert result_form.has_content? rule1.title

    result_form.fill_in "result_location", :with => location
    result_form.fill_in Assessment::TYPES[:paradox][:questions][1][:text], :with => "233"
    select_from_chosen "Some", :from => Assessment::TYPES[:paradox][:questions][2][:text]

    click_on "Update Study"

    visit edit_study_path(study)

    assert page.has_selector?("#original_results .well", :count => 1)
    assert page.has_content? rule1.title
    assert_equal location, find("#result_location").value

    select_from_chosen rule2.title, :from => "rule_id"
    click_on "Add New Original Result"

    assert page.has_selector?(".well", :count => 2)



    page.first(:css, ".well").click_on("delete")

    result_form = page.find(".well", :visible => true)
    result_form.fill_in "result_location", :with => location
    result_form.fill_in Assessment::TYPES[:paradox][:questions][1][:text], :with => "2333"


    click_on "Update Study"

    visit edit_study_path(study)
    assert page.has_selector?(".well", :count => 1)
  end


end