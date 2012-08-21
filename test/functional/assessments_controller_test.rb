require 'test_helper'

class AssessmentsControllerTest < ActionController::TestCase
  setup do
    @assessment = assessments(:one)
    @current_user = login(users(:admin))
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assessments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assessment" do
    assert_difference('Assessment.count') do
      post :create, assessment: { assessment_type: @assessment.assessment_type, result_id: @assessment.result_id }
    end

    assert_redirected_to assessment_path(assigns(:assessment))
  end

  test "should show assessment" do
    get :show, id: @assessment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @assessment
    assert_response :success
  end

  test "should update assessment" do
    put :update, id: @assessment, assessment: { assessment_type: @assessment.assessment_type, result_id: @assessment.result_id }
    assert_redirected_to assessment_path(assigns(:assessment))
  end

  test "should destroy assessment" do
    assert_difference('Assessment.current.count', -1) do
      delete :destroy, id: @assessment
    end

    assert_redirected_to assessments_path
  end
end
