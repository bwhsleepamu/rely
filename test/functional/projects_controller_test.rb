require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @current_user = create(:user)
    @project = create(:project, owner_id: @current_user.id)
    @template = build(:project)

    login(@current_user)
  end

  test "should get index with projects user can manage" do
    create :project
    p = create :project
    p.managers << @current_user
    assert p.save

    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
    assert_equal 2, assigns(:projects).to_a.count
  end

  test "should get paginated index" do
    get :index, format: 'js'
    assert_not_nil assigns(:projects)
    assert_template 'index'
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    scorers = create_list :user, 4
    managers = create_list :user, 2

    s_ids = scorers.map {|s| s.id}
    m_ids = managers.map {|m| m.id}

    assert_difference('Project.count') do
      post :create, project: { description: @template.description, end_date: @template.end_date, name: @template.name, start_date: @template.start_date, scorer_ids: s_ids, manager_ids: m_ids }
    end

    assert_not_nil assigns(:project)
    assert_equal @current_user, assigns(:project).owner
    assert_equal assigns(:project).scorers.map{|s| s.id}.sort, s_ids.sort
    assert_equal assigns(:project).managers.map{|m| m.id}.sort, m_ids.sort

    assert_redirected_to projects_path
  end

  test "should automatically make project owner a manager, even with no other managers defined" do
    scorers = create_list :user, 4

    s_ids = scorers.map {|s| s.id}
    m_ids = nil

    assert_difference('Project.count') do
      post :create, project: { description: @template.description, end_date: @template.end_date, name: @template.name, start_date: @template.start_date, scorer_ids: s_ids, manager_ids: m_ids }
    end

    assert @current_user.all_projects.include?(assigns(:project))
  end

  test "should show project" do
    get :show, id: @project.id
    assert_response :success
  end

  test "should not show project not accessible by user" do
    project = create :project
    get :show, id: project.id

    assert_redirected_to projects_path
  end

  test "should get edit" do
    get :edit, id: @project.id
    assert_response :success
  end

  test "should not edit project not accessible by user" do
    project = create :project

    get :edit, id: project.id
    assert_redirected_to projects_path
  end

  test "should update project" do
    new_scorer = create :user
    new_manager = create :user

    scorer_ids = [@project.scorers.first.id, new_scorer.id]
    manager_ids = [new_manager.id]

    put :update, id: @project.id, project: { description: @template.description, end_date: @template.end_date, start_date: @template.start_date, scorer_ids: scorer_ids, manager_ids: manager_ids }

    assert_not_nil assigns(:project)
    assert_equal @current_user, assigns(:project).owner
    assert_equal @template.description, assigns(:project).description
    assert_equal assigns(:project).scorers.map{|s| s.id}.sort, scorer_ids.sort
    assert_equal assigns(:project).managers.map{|m| m.id}.sort, manager_ids.sort

    assert_redirected_to projects_path
  end

  test "should not update project not accessible by user" do
    project = create :project

    put :update, id: project.id, project: { name: @template.name, description: @template.description, end_date: @template.end_date, start_date: @template.start_date }

    assert_not_equal @template.name, project.name
    assert_redirected_to projects_path
  end


  test "should destroy project" do
    assert_difference('Project.current.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end

  test "should not destroy project not accessible by user" do
    project = create :project

    assert_difference('Project.current.count', 0) do
      delete :destroy, id: project.id
    end

    assert_redirected_to projects_path
  end

end
