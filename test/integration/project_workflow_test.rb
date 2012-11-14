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

    show_page

    # name
    # description
    # start date
    # end date
    # managers
    # scorers

    fill_in "Name", :with => template.name
    fill_in "Description", :with => template.description
    # choose dates

    managers.each do |m|
      select_from_chosen m.full_name, :from => "Managers"
    end

    scorers.each do |s|
      select_from_chosen s.full_name, :from => "Scorers"
    end

    click_on "Create Project"
  end
end