require 'test_helper'

class StudiesControllerTest < ActionController::TestCase
  setup do
    @study = studies(:one)
    @current_user = login(users(:admin))
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:studies)
  end

  test "should get paginated index" do
    get :index, format: 'js'
    assert_not_nil assigns(:studies)
    assert_template 'index'
  end


  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create study" do
    assert_difference('Study.count') do
      post :create, study: { location: @study.location, original_id: "original id 1", study_type_id: @study.study_type_id }
    end

    assert_redirected_to study_path(assigns(:study))
  end

  test "should show study" do
    get :show, id: @study
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @study
    assert_response :success
  end

  test "should update study" do
    put :update, id: @study, study: { location: @study.location, original_id: @study.original_id, study_type_id: @study.study_type_id }
    assert_redirected_to study_path(assigns(:study))
  end

  test "should destroy study" do
    assert_difference('Study.current.count', -1) do
      delete :destroy, id: @study
    end

    assert_redirected_to studies_path
  end
end
