require 'test_helper'

class ReliabilityIdsControllerTest < ActionController::TestCase
  setup do
    @reliability_id = reliability_ids(:one)
    @current_user = login(users(:admin))
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reliability_ids)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reliability_id" do
    assert_difference('ReliabilityId.count') do
      post :create, reliability_id: { study_id: @reliability_id.study_id, user_id: @reliability_id.user_id, exercise_id: @reliability_id.exercise_id }
    end

    assert_redirected_to reliability_id_path(assigns(:reliability_id))
  end

  test "should show reliability_id" do
    get :show, id: @reliability_id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @reliability_id
    assert_response :success
  end

  test "should update reliability_id" do
    put :update, id: @reliability_id, reliability_id: { study_id: @reliability_id.study_id, user_id: @reliability_id.user_id, exercise_id: @reliability_id.exercise_id }
    assert_redirected_to reliability_id_path(assigns(:reliability_id))
  end

  test "should destroy reliability_id" do
    assert_difference('ReliabilityId.current.count', -1) do
      delete :destroy, id: @reliability_id
    end

    assert_redirected_to reliability_ids_path
  end
end
