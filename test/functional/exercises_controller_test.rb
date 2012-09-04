require 'test_helper'

class ExercisesControllerTest < ActionController::TestCase
  setup do
    @exercise = exercises(:one)
    @current_user = login(users(:admin))
  end

  test "should get index of only assigned exercises as scorer" do
    user = users(:valid)
    login(users(:valid))
    get :index

    assert_response :success
    assert_not_nil assigns(:exercises)
    assert_equal user.assigned_exercises.count, assigns(:exercises).count
  end

  test "should get index of all exercises as system admin" do
    get :index
    assert_response :success
    assert_not_nil assigns(:exercises)
    assert_equal Exercise.current.count, assigns(:exercises).count
  end

  test "should get paginated index as system admin" do
    get :index, format: 'js'
    assert_not_nil assigns(:exercises)
    assert_template 'index'
  end

  test "should get paginated index of assigned exercises as scorer" do
    user = users(:valid)
    login(users(:valid))
    get :index, format: 'js'

    assert_not_nil assigns(:exercises)
    assert_template 'index'
    assert_equal user.assigned_exercises.count, assigns(:exercises).count
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create exercise" do
    user_ids = [users(:valid).id, users(:two).id]
    group_ids = [groups(:one).id, groups(:two).id]

    assert_difference('Exercise.count') do
      post :create, exercise: { assessment_type: @exercise.assessment_type,
                                description: @exercise.description, name: @exercise.name + "_new", rule_id: @exercise.rule_id,
                                scorer_ids: user_ids, group_ids: group_ids }
    end

    assert_redirected_to exercise_path(assigns(:exercise))
    assert_equal assigns(:exercise).scorers.count, user_ids.count
    assert_equal assigns(:exercise).groups.count, group_ids.count
  end

  test "should show assigned exercise to scorer" do
    exercise = create(:exercise)
    user = exercise.scorers.first
    login(user)

    get :show, id: exercise
    assert_response :success
  end

  test "should show any exercise to admin" do
    exercise = create(:exercise)
    get :show, id: exercise
    assert_response :success
  end

  test "should not show unassigned exercise to scorer" do
    user = users(:two)
    exercise = exercises(:two)
    login(user)

    assert_equal false, user.assigned_exercises.include?(exercise)
    get :show, id: exercise
    assert_redirected_to exercises_path
  end

  test "should get edit" do
    get :edit, id: @exercise
    assert_response :success
  end

  test "should update exercise" do
    put :update, id: @exercise, exercise: { assessment_type: @exercise.assessment_type, description: @exercise.description, name: @exercise.name + "_update", rule_id: @exercise.rule_id }
    assert_redirected_to exercise_path(assigns(:exercise))
  end

  test "should destroy exercise" do
    assert_difference('Exercise.current.count', -1) do
      delete :destroy, id: @exercise
    end

    assert_redirected_to exercises_path
  end
end
