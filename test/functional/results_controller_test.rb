require 'test_helper'

class ResultsControllerTest < ActionController::TestCase
  setup do
    @result = create(:result)
    @template = build(:result)
    @current_user = login(users(:admin))
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:results)
  end

  test "should not get new since no associated study" do
    get :new
    assert_redirected_to root_path
  end

  test "should not create result since admin is not assigned to study" do
    assert_no_difference('Result.count') do
      post :create, result: { location: @result.location, result_type: @result.result_type }
    end

    assert_redirected_to root_path
  end

  #test "should show result" do
  #  get :show, id: @result
  #  assert_response :success
  #end

  test "should not get edit since admin not assigned to study" do
    get :edit, id: @result
    assert_redirected_to root_path
  end

  test "should not update result since admin not assigned to study" do
    put :update, id: @result, result: { location: @result.location, result_type: @result.result_type }
    assert_redirected_to root_path
  end

  test "should destroy result" do
    assert_difference('Result.current.count', -1) do
      delete :destroy, id: @result
    end

    assert_redirected_to results_path
  end

  # Scorer Access

  test "should get new with reliability_id if study assigned to current user" do
    exercise = create(:exercise)
    user = exercise.scorers.first
    reliability_id = user.reliability_ids.where(:exercise_id => exercise.id).first

    login(user)

    get :new, reliability_id: reliability_id
    assert_not_nil assigns(:result).reliability_id
    assert_response :success
  end

  test "should not get new with reliability_id if study not assigned to current user" do
    login(users(:valid))

    get :new, reliability_id: reliability_ids(:three)
    assert_redirected_to root_path
  end

  test "should create result for study assigned to current user" do
    scorer = users(:valid)
    login(scorer)
    exercise = create(:exercise)
    exercise.scorers << scorer
    exercise.save
    rid = exercise.reliability_ids.where(user_id: scorer.id).first

    #MY_LOG.info "errors: #{exercise.errors.full_messages} \neid: #{exercise.id} #{exercise.scorers} | #{scorer} | #{exercise.scorers.include?(scorer)}"
    assert_difference('Result.count') do
      post :create, result: { location: "some location", result_type: "rescored", assessment_answers: {"1"=>"233", "2"=>"2", :assessment_type => exercise.rule.assessment_type}, reliability_id: rid.id }
    end

    assert_not_nil assigns(:result).assessment
    assert_equal false, assigns(:result).assessment.assessment_results.empty?

    assert_redirected_to exercise_path(assigns(:result).reliability_id.exercise)
  end

  test "should not create result for study not assigned to current user" do
    scorer = users(:valid)
    login(scorer)
    create(:exercise)

    assert_no_difference('Result.count') do
      post :create, result: { location: "some location", result_type: "rescored" }
    end
  end

  test "should get edit since user assigned to study" do
    scorer = users(:valid)
    login(scorer)
    exercise = create(:exercise)
    exercise.scorers << scorer
    exercise.save

    rid = exercise.reliability_ids.where(:user_id => scorer.id).first

    result = create(:result)
    rid.result = result
    rid.save

    get :edit, id: result
    assert_response :success
    assert_equal result, assigns(:result)
  end


  test "should update result for study assigned to current user" do
    scorer = users(:valid)
    login(scorer)
    exercise = create(:exercise)
    exercise.scorers << scorer
    exercise.save

    rid = exercise.reliability_ids.where(:user_id => scorer.id).first
    result = create(:result)
    rid.result = result
    rid.save

    put :update, id: result, result: { location: result.location, result_type: result.result_type }
    assert_redirected_to exercise_path(assigns(:result).reliability_id.exercise)
  end

  test "should show result by reliability_id if study assigned to current user" do
    pending "Not needed yet."
    login(users(:valid))


  end

  test "should not show result if study not assigned to current user" do
    pending "Not needed yet."
    login(users(:valid))

  end

end
