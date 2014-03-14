require 'test_helper'

SimpleCov.command_name "test:integration"

class ProjectWorkflowTest < ActionDispatch::IntegrationTest
  def setup
    @user = login_user
  end

  test "should allow user to create a project" do
    users = create_list :user, 10
    managers = users[0..1]
    scorers = users[2..6]
    template = build(:project)

    visit projects_path
    click_on "Create Project"

    managers.each do |m|
      select_from_chosen m.name, :from => "Managers"
    end

    scorers.each do |s|
      select_from_chosen s.name, :from => "Scorers"
    end

    # choose dates
    fill_in "Start Date", :with => template.start_date.strftime("%m/%d/%Y")
    fill_in "End Date", :with => template.end_date.strftime("%m/%d/%Y")

    # name
    # description
    fill_in "Name", :with => template.name
    fill_in "Description", :with => template.description

    #click_on("#project_name")

    page.find('#project_name').trigger(:focus)

    assert_difference('Project.count') do
      click_on "Create Project"
    end

    assert page.has_content? template.name
    assert page.has_content? template.description
    assert page.has_content? "Today"
    #assert page.has_content? ApplicationHelper.simple_date template.end_date.strftime("%Y-%m-%d")

    #managers.each do |m|
    #  assert page.has_content? m.name
    #end
    #
    #scorers.each do |s|
    #  assert page.has_content? s.name
    #end
  end
end
