require 'test_helper'

SimpleCov.command_name "test:integration"

class RuleWorkflowTest < ActionDispatch::IntegrationTest
  def setup
    @project = create :project
    @user = @project.managers.first
    login_user(@user)
  end

  test "should be able to create rule" do
    title = "Test Rule"
    procedure = "Test rule procedure for how to score these things."
    assessment_type = Assessment::TYPES[:paradox]

    visit rules_path
    show_page

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



end