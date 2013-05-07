require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  setup do
    @project = create :project
    @current_user = @project.managers.first
    @group = @project.groups.first
    @template = build :group
    login(@current_user)
  end

  test "should get index with viewable groups" do
    create :project
    get :index
    assert_not_nil assigns(:groups)
    assert_equal assigns(:groups).count, @current_user.all_groups.count
    assert assigns(:groups).count < Group.current.count
    assert_response :success
  end

  test "should get paginated index" do
    get :index, format: 'js'
    assert_not_nil assigns(:groups)
    assert_template 'index'
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create group" do
    assert_difference('Group.count') do
      post :create, group: { description: @template.description, name: @template.name, project_id: @project.id }
    end

    assert_equal @current_user, assigns(:group).creator
    assert_redirected_to groups_path
  end

  test "should create group with associated studies" do
    study_ids = @project.studies.map {|s| s.id}

    assert_difference('Group.count') do
      post :create, group: { description: @template.description, name: @template.name, project_id: @project.id, study_ids: study_ids }
    end

    assert_equal assigns(:group).studies.count, @project.studies.count
    assert_redirected_to groups_path
  end

  test "should show group" do
    get :show, id: @group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @group
    assert_response :success
  end

  test "should update group" do
    put :update, id: @group, group: { description: @group.description, name: @group.name }
    assert_redirected_to groups_path
  end

  test "should destroy group" do
    assert_difference('Group.current.count', -1) do
      delete :destroy, id: @group
    end

    assert_redirected_to groups_path
  end
end
