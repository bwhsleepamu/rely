require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @project = create(:project)
    @template = build(:project)
    @current_user = create(:user)

    login(@current_user)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
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

    assert_redirected_to project_path(assigns(:project))
  end

  test "should show project" do
    get :show, id: @project
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project
    assert_response :success
  end

  test "should update project" do
    group_ids = [groups(:one).id, groups(:two).id]
    put :update, id: @project, project: { description: @project.description, end_date: @project.end_date, name: @project.name, start_date: @project.start_date, group_ids: group_ids }
    assert_not_nil assigns(:project)
    assert_equal group_ids.count, assigns(:project).groups.count
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
    assert_difference('Project.current.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end
end
