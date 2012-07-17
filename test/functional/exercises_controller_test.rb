require 'test_helper'

class ExercisesControllerTest < ActionController::TestCase
  setup do
    @exercise = exercises(:one)
    @current_user = login(users(:admin))
  end

  test "should get index as normal user" do
    login(users(:valid))
    get :index
    assert_response :success
    assert_not_nil assigns(:exercises)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:exercises)
  end

  test "should get paginated index" do
    get :index, format: 'js'
    assert_not_nil assigns(:exercises)
    assert_template 'index'
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create exercise" do
    assert_difference('Exercise.count') do
      post :create, exercise: { admin_id: @exercise.admin_id, assessment_type: @exercise.assessment_type, assigned_at: @exercise.assigned_at, completed_at: @exercise.completed_at, deleted: @exercise.deleted, description: @exercise.description, name: @exercise.name, rule_id: @exercise.rule_id }
    end

    assert_redirected_to exercise_path(assigns(:exercise))
  end

  test "should show exercise" do
    get :show, id: @exercise
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @exercise
    assert_response :success
  end

  test "should update exercise" do
    put :update, id: @exercise, exercise: { admin_id: @exercise.admin_id, assessment_type: @exercise.assessment_type, assigned_at: @exercise.assigned_at, completed_at: @exercise.completed_at, deleted: @exercise.deleted, description: @exercise.description, name: @exercise.name, rule_id: @exercise.rule_id }
    assert_redirected_to exercise_path(assigns(:exercise))
  end

  test "should destroy exercise" do
    assert_difference('Exercise.count', -1) do
      delete :destroy, id: @exercise
    end

    assert_redirected_to exercises_path
  end
end
