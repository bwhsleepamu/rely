# Pagination, Search, and Ordering

require 'test_helper'

SimpleCov.command_name "test:integration"

class IndexWorkflowTest < ActionDispatch::IntegrationTest
  def setup
    @projects = create_list(:project, 6)
    @user = login_user
    @projects.each {|p| p.managers << @user}

  end

  # groups, studies, projects, rules, study_types
  test "should paginate, search, and order index pages for all relevant models." do
    #Capybara.current_driver = :selenium
    [
        [:projects, @user.all_projects, projects_path, @projects.last.name],
        [:groups, @user.all_groups, groups_path, @user.all_groups.last.name],
        [:studies, @user.all_studies, studies_path, @user.all_studies.last.original_id],
        [:rules, @user.all_rules, rules_path, @user.all_rules.last.title],
        [:study_types, @user.all_study_types, study_types_path, @user.all_study_types.last.name]
    ].each do |model|
      visit model[2]

      page.find("#count_5")

      click_on "count_5"


      assert page.find("tbody").has_selector?("tr", :count => 5)

      fill_in "search", :with => model[3]
      click_on "Search"

#      assert page.find("tbody").has_selector?("tr", :count => 1)

    end

  end

  test "should show project column search on associated project name." do
    [
        [:groups, @user.all_groups, groups_path, @user.all_groups.last.project.name],
        [:studies, @user.all_studies, studies_path, @user.all_studies.last.project.name],
        [:rules, @user.all_rules, rules_path, @user.all_rules.last.project.name],
        [:study_types, @user.all_study_types, study_types_path, @user.all_study_types.last.project.name]
    ].each do |model|
      visit model[2]

      assert page.find("thead").has_content?("Project")

      fill_in "search", :with => model[3]
      click_on "Search"

      assert page.find("tbody").has_selector?("tr")
    end

  end

end