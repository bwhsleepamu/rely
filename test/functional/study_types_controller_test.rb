require 'test_helper'

class StudyTypesControllerTest < ActionController::TestCase
  setup do
    @study_type = study_types(:one)
    @current_user = login(users(:admin))
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:study_types)
  end

  test "should get paginated index" do
    get :index, format: 'js'
    assert_not_nil assigns(:study_types)
    assert_template 'index'
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create study type" do
    assert_difference('StudyType.count') do
      post :create, study_type: { description: @study_type.description, name: @study_type.name + "_c" }
    end

    assert_redirected_to study_type_path(assigns(:study_type))
  end

  test "should show study type" do
    get :show, id: @study_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @study_type
    assert_response :success
  end

  test "should update study type" do
    put :update, id: @study_type, study_type: { description: @study_type.description, name: @study_type.name }
    assert_redirected_to study_type_path(assigns(:study_type))
  end

  test "should destroy study study type" do
    assert_difference('StudyType.current.count', -1) do
      delete :destroy, id: @study_type
    end

    assert_redirected_to study_types_path
  end
end
