require 'test_helper'

class ResultsControllerTest < ActionController::TestCase
  setup do
    @project = create :project
    @current_user = @project.managers.first
    @result = create(:result)
    @template = build(:result)

    login(@current_user)
  end

  # Scorer Access

  test "should get new with reliability_id if study assigned to current user" do
    exercise = create(:exercise)
    user = exercise.scorers.first
    reliability_id = user.reliability_ids.where(:exercise_id => exercise.id).first

    login user

    get :new, reliability_id: reliability_id
    assert_not_nil assigns(:result).reliability_id
    assert_response :success
  end

  test "should not get new with reliability_id if study not assigned to current user" do
    exercise = create :exercise
    get :new, reliability_id: exercise.reliability_ids.first

    assert_redirected_to root_path
  end

  test "should create result for study assigned to current user" do
    scorer = @project.scorers.first
    exercise = create :exercise, existing_project_id: @project.id
    assert exercise.scorers.include?(scorer)
    login scorer

    rid = exercise.reliability_ids.where(user_id: scorer.id).first
    assert scorer.all_reliability_ids.find_by_id(rid)

    #MY_LOG.info "errors: #{exercise.errors.full_messages} \neid: #{exercise.id} #{exercise.scorers} | #{scorer} | #{exercise.scorers.include?(scorer)}"

    assert_difference('Result.count') do
      post :create, result: { location: "some location", result_type: "rescored", assessment_answers: {"1"=>"233", "2"=>"2", :assessment_type => exercise.rule.assessment_type}, reliability_id: rid.id }
    end

    assert_not_nil assigns(:result).assessment
    assert_equal false, assigns(:result).assessment.assessment_results.empty?

    assert_redirected_to show_assigned_exercise_path(assigns(:result).reliability_id.exercise)
  end

  test "should not create result for study not assigned to current user" do
   create :exercise

    assert_no_difference('Result.count') do
      post :create, result: { location: "some location", result_type: "rescored" }
    end
  end

  test "should get edit since user assigned to study" do
    exercise = create(:exercise, existing_project_id: @project.id)
    scorer = exercise.scorers.first

    login scorer

    rid = exercise.reliability_ids.where(:user_id => scorer.id).first

    result = create(:result)
    rid.result = result
    rid.save

    get :edit, id: result
    assert_response :success
    assert_equal result, assigns(:result)
  end


  test "should update result for study assigned to current user" do
    exercise = create(:exercise, existing_project_id: @project.id)
    scorer = exercise.scorers.first

    login scorer

    rid = exercise.reliability_ids.where(:user_id => scorer.id).first
    result = create(:result)
    rid.result = result
    rid.save

    put :update, id: result, result: { location: @template.location, result_type: @template.result_type }
    assert_redirected_to show_assigned_exercise_path(assigns(:result).reliability_id.exercise)
  end

end
