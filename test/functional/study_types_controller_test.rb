require 'test_helper'

class StudyTypesControllerTest < ActionController::TestCase
  setup do
    @project = create :project
    @current_user = @project.managers.first
    @study_type = @project.study_types.first
    @template = build :study_type
    login(@current_user)
  end

  test "should get index" do
    create :project
    get :index
    assert_not_nil assigns(:study_types)
    assert_equal assigns(:study_types).count, @current_user.all_study_types.count
    assert assigns(:study_types).count < StudyType.current.count
    assert_response :success
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
      post :create, study_type: { description: @template.description, name: @template.name, project_id: @project.id }
    end

    assert_equal @current_user, assigns(:study_type).creator
    assert_redirected_to study_types_path
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
    put :update, id: @study_type, study_type: { description: @template.description, name: @template.name }
    assert_redirected_to study_types_path
  end

  test "should destroy study study type" do
    assert_difference('StudyType.current.count', -1) do
      delete :destroy, id: @study_type
    end

    assert_redirected_to study_types_path
  end
end
