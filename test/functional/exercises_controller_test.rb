require 'test_helper'

class ExercisesControllerTest < ActionController::TestCase
  setup do
    @exercise = create(:exercise)
    @project = @exercise.project
    @current_user = @project.managers.first
    @template = build(:exercise)
    login(@current_user)
  end

  # index
  test "should get index of exercises assigned to as scorer" do
    project = create(:project)
    project.scorers << @current_user
    create(:exercise)
    my_exercise = create(:exercise, existing_project_id: project.id)

    get :index
    assert_response :success
    assert_not_nil assigns(:assigned_exercises)
    assert @current_user.assigned_exercises.count < Exercise.current.count
    assert_equal @current_user.assigned_exercises.count, assigns(:assigned_exercises).count
  end

  test "should get index of exercises that can be managed" do
    get :index
    create(:exercise)

    assert_response :success
    assert_not_nil assigns(:managed_exercises)
    assert assigns(:managed_exercises).length < Exercise.current.count
    assert_equal assigns(:managed_exercises).count, @current_user.all_exercises.count
  end

  test "should get paginated index" do
    get :index, format: 'js'
    assert_not_nil assigns(:managed_exercises)
    assert_not_nil assigns(:assigned_exercises)

    assert_template 'index'
  end


  test "should get new" do
    get :new, project_id: @project.id # refactor!
    assert_response :success
  end

  test "should create exercise" do
    users = @project.scorers
    groups =  @project.groups
    user_ids = users.map{|u| u.id}
    group_ids = groups.map{|g| g.id}
    rule_id = @project.rules.first.id

    assert_difference('Exercise.count') do
      post :create, exercise: { description: @template.description, name: @template.name, rule_id: rule_id,
                                scorer_ids: user_ids, group_ids: group_ids, project_id: @project.id }
    end

    assert_redirected_to exercise_path(assigns(:exercise))
    assert_equal assigns(:exercise).scorers.count, user_ids.count
    assert_equal assigns(:exercise).groups.count, group_ids.count
  end

  test "should show assigned exercise to scorer" do
    exercise = create(:exercise)
    user = exercise.scorers.first
    login(user)

    get :show_assigned, id: exercise
    assert_response :success
  end

  test "should show exercise to user that can manage it" do
    get :show, id: @exercise
    assert_response :success
  end

  test "should not show unassigned exercise to scorer" do
    user = create(:user)
    login(user)

    assert_equal false, user.assigned_exercises.include?(@exercise)
    get :show_assigned, id: @exercise
    assert_redirected_to root_path
  end

  test "should not show exercise from unmanaged project to user" do
    exercise = create(:exercise)
    get :show, id: exercise
    assert_redirected_to root_path
  end


  test "should get edit" do
    get :edit, id: @exercise
    assert_response :success
  end

  test "should update exercise" do
    put :update, id: @exercise, exercise: { description: @template.description, name: @template.name + "_update" }
    assert_redirected_to exercise_path(assigns(:exercise))
  end

  test "should destroy exercise" do
    assert_difference('Exercise.current.count', -1) do
      delete :destroy, id: @exercise
    end

    assert_redirected_to exercises_path
  end
end
