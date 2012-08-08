require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @project = projects(:one)
    @current_user = login(users(:admin))
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
    group_ids = [groups(:one).id, groups(:two).id]
    assert_difference('Project.count') do
      post :create, project: { deleted: @project.deleted, description: @project.description, end_date: @project.end_date, name: @project.name, start_date: @project.start_date, group_ids: group_ids }
    end

    assert_not_nil assigns(:project)
    assert_equal group_ids.count, assigns(:project).groups.count
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
    put :update, id: @project, project: { deleted: @project.deleted, description: @project.description, end_date: @project.end_date, name: @project.name, start_date: @project.start_date, group_ids: group_ids }
    assert_not_nil assigns(:project)
    assert_equal group_ids.count, assigns(:project).groups.count
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end
end
