require 'test_helper'

class AssessmentResultsControllerTest < ActionController::TestCase
  setup do
    @assessment_result = assessment_results(:one)
    @current_user = login(users(:admin))
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assessment_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assessment_result" do
    assert_difference('AssessmentResult.count') do
      post :create, assessment_result: { answer: @assessment_result.answer, assessment_id: @assessment_result.assessment_id, deleted: @assessment_result.deleted, question_id: @assessment_result.question_id }
    end

    assert_redirected_to assessment_result_path(assigns(:assessment_result))
  end

  test "should show assessment_result" do
    get :show, id: @assessment_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @assessment_result
    assert_response :success
  end

  test "should update assessment_result" do
    put :update, id: @assessment_result, assessment_result: { answer: @assessment_result.answer, assessment_id: @assessment_result.assessment_id, deleted: @assessment_result.deleted, question_id: @assessment_result.question_id }
    assert_redirected_to assessment_result_path(assigns(:assessment_result))
  end

  test "should destroy assessment_result" do
    assert_difference('AssessmentResult.count', -1) do
      delete :destroy, id: @assessment_result
    end

    assert_redirected_to assessment_results_path
  end
end
