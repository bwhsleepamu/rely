require 'test_helper'

SimpleCov.command_name "test:integration"

class GroupWorkflowTest < ActionDispatch::IntegrationTest
  def setup
    @project = create :project
    @user = @project.managers.first
    login_user(@user)
  end

  test "should be able to create a group of studies" do
    group_name = "Test Group"
    description = "This is a description of group that consists of many studies."

    visit groups_path
    click_on "Create Group"
    fill_in 'Name', :with => group_name
    fill_in 'Description', :with => description
    assert find("#group_study_ids").has_selector?("option", :count => @project.studies.count), "Available studies are not all shown in select."

    0.upto(@project.studies.count - 2) do |i|
      select_from_chosen @project.studies[i].long_name, :from => "Studies"
    end

    click_button "Create Group"

    assert has_content?("Group was successfully created.")
    assert has_content?(group_name), "No group name displayed."
    assert has_content?(description), "No description displayed"

    0.upto(@project.studies.count - 2) do |i|
      assert has_content?(@project.studies[i].to_s)
    end
  end


  private

  def setup_for_group_creation(study_count)
    study_type = create(:study_type)
    create_list(:study, study_count, study_type: study_type)
  end
end