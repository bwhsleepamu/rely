require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  setup do
    @group = groups(:one)
    @current_user = login(users(:admin))
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:groups)
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

  test "should create group and assign creator" do
    assert_difference('Group.count') do
      post :create, group: { description: @group.description, name: @group.name }
    end

    assert_redirected_to group_path(assigns(:group))
    assert_equal assigns(:group).creator.id, @current_user[1][0]
  end

  test "should create group with associated studies" do

    assert_difference('Group.count') do
      post :create, group: { description: @group.description, name: @group.name,
                             study_ids: [studies(:one).id, studies(:three).id, studies(:five).id] }
    end

    assert_equal assigns(:group).studies.count, 3
    assert_redirected_to group_path(assigns(:group))
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
    assert_redirected_to group_path(assigns(:group))
  end

  test "should destroy group" do
    assert_difference('Group.current.count', -1) do
      delete :destroy, id: @group
    end

    assert_redirected_to groups_path
  end
end
