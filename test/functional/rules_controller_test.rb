require 'test_helper'

class RulesControllerTest < ActionController::TestCase
  setup do
    @current_user = create :user
    @project = create :project, owner: @current_user
    @rule = @project.rules.first
    @template = build(:rule)

    @not_managed_project = create :project

    login(@current_user)
  end

  test "should get index" do
    get :index
    assert_response :success

    assert_not_nil assigns(:rules)
    assert_equal @project.rules.length, assigns(:rules).to_a.length
  end

  test "should get paginated index" do
    get :index, format: 'js'
    assert_not_nil assigns(:rules)
    assert_template 'index'
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rule" do
    assert_difference('Rule.count') do
      post :create, rule: { procedure: @template.procedure, title: @template.title, assessment_type: @template.assessment_type, project_id: @project.id  }
    end

    assert_equal @current_user, assigns(:rule).creator
    assert_redirected_to rule_path(assigns(:rule))
  end

  test "should not create rule if project not managable by user" do
    assert_difference('Rule.count', 0 ) do
      post :create, rule: { procedure: @template.procedure, title: @template.title, assessment_type: @template.assessment_type, project_id: @not_managed_project.id  }
    end

    assert_redirected_to rules_path
  end

  test "should show rule as admin" do
    get :show, id: @rule
    assert_response :success
  end

  test "should show rule as scorer" do
    login(users(:valid))
    get :show, id: @rule
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rule
    assert_response :success
  end

  test "should update rule" do
    put :update, id: @rule, rule: { procedure: @template.procedure, title: @template.title }
    assert_redirected_to rule_path(assigns(:rule))
  end

  test "should destroy rule" do
    assert_difference('Rule.current.count', -1) do
      delete :destroy, id: @rule
    end

    assert_redirected_to rules_path
  end
end
