require 'test_helper'

class ExercisesControllerTest < ActionController::TestCase
  setup do
    @exercise = exercises(:one)
    @current_user = login(users(:admin))
  end

  test "should get index of only associated exercises as normal user" do
    user = users(:valid)
    login(users(:valid))
    get :index

    assert_response :success
    assert_not_nil assigns(:exercises)
    assert_equal user.exercises.count, assigns(:exercises).count
  end

  test "should get index of all exercises as system admin" do
    get :index
    assert_response :success
    assert_not_nil assigns(:exercises)
    assert_equal Exercise.current.count, assigns(:exercises).count
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
    user_ids = [users(:valid).id, users(:two).id]
    group_ids = [groups(:one).id, groups(:two).id]

    assert_difference('Exercise.count') do
      post :create, exercise: { assessment_type: @exercise.assessment_type, deleted: @exercise.deleted,
                                description: @exercise.description, name: @exercise.name, rule_id: @exercise.rule_id,
                                user_ids: user_ids, group_ids: group_ids }
    end

    assert_redirected_to exercise_path(assigns(:exercise))
    assert_equal assigns(:exercise).users.count, user_ids.count
    assert_equal assigns(:exercise).groups.count, group_ids.count
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
    put :update, id: @exercise, exercise: { assessment_type: @exercise.assessment_type, deleted: @exercise.deleted, description: @exercise.description, name: @exercise.name, rule_id: @exercise.rule_id }
    assert_redirected_to exercise_path(assigns(:exercise))
  end

  test "should destroy exercise" do
    assert_difference('Exercise.count', -1) do
      delete :destroy, id: @exercise
    end

    assert_redirected_to exercises_path
  end
end
