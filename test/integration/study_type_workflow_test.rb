require 'test_helper'

SimpleCov.command_name "test:integration"

class StudyTypeWorkflowTest < ActionDispatch::IntegrationTest
  def setup
    @project = create :project
    @user = @project.managers.first
    login_user(@user)
  end

  test "should be able to create a study type" do
    study_type_name = "Test Study Type"
    description = "Study type description is here."

    visit study_types_path
    click_on "Create Study Type"

    select_from_chosen @project.name, :from => "Project"

    f = page.find("form")
    f.fill_in "Name", :with => study_type_name
    f.fill_in "Description", :with => description
    assert has_no_content?('Deleted'), 'Deleted flag should not show up'

    click_button "Create Study Type"

    assert has_content?("Study type was successfully created."), "No success message shown."
    assert has_content?(study_type_name), "No study type name shown"
    assert has_content?(description), "No study type description shown"
  end
end