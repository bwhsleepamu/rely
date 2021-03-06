require 'test_helper'

class StudiesControllerTest < ActionController::TestCase
  setup do

    @project = create :project
    @current_user = @project.managers.first
    @study = @project.studies.first
    @template = build :study
    @study_with_results = create :study_with_original_results, project: @project, study_type: @project.study_types.first, creator: @current_user, updater_id: @current_user.id

    #MY_LOG.info @study_with_results.valid?
    #MY_LOG.info @study_with_results.original_results.length

    #MY_LOG.info @study_with_results.study_original_results.length

    #MY_LOG.info @study_with_results.study_original_results.map {|sor| sor.valid?}

    login(@current_user)
  end

  test "should get index" do
    create :project
    get :index

    assert_not_nil assigns(:studies)
    assert_equal assigns(:studies).count, @current_user.all_studies.count
    assert assigns(:studies).count < Study.current.count
    assert_response :success
  end

  test "should get paginated index" do
    get :index, format: 'js'
    assert_not_nil assigns(:studies)
    assert_template 'index'
  end


  test "should get new" do
    assert_not_nil @study.project
    get :new
    assert_response :success
  end

  test "should create study" do
    assert_difference('Study.current.count') do
      post :create, study: { location: @template.location, original_id: @template.original_id, study_type_id: @project.study_types.first.id, project_id: @project.id }
    end

    assert_equal @project, assigns(:study).project
    assert_equal @current_user, assigns(:study).creator
    assert_redirected_to studies_path
  end

  test "should create study with original results" do
    assert_difference('Study.current.count') do
      post :create, study: { location: @template.location, original_id: @template.original_id, study_type_id: @project.study_types.first.id, project_id: @project.id, results:
          [{ rule_id: @project.rules.first.id, location: "/best/place/ever/1", delete: "0",  assessment_answers: [{question_id: "1", answer: "2"}, {question_id: "2", answer: "11"}]  }, {rule_id: @project.rules.last.id, location: "/best/place/ever/2", delete: "0", assessment_answers: {:assessment_type => "{:value=>\"paradox\"}", "1" => "1", "2" => "1" }   }]
      }
    end

    assert_equal 2, assigns(:study).original_results.count
    assert_redirected_to studies_path
  end

  test "should show study" do
    get :show, id: @study
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @study
    assert_response :success
  end

  test "should update study" do
    put :update, id: @study, study: { location: @study.location, original_id: @study.original_id, study_type_id: @study.study_type_id }
    assert_redirected_to studies_path
  end

  test "should update study with original results" do
    new_rule = create :rule, project: @project, updater_id: @current_user.id, creator: @current_user
    new_location = "new_location/up/in/here"
    @study_with_results.reload

    assert_equal 2, @study_with_results.study_original_results.count

    sor1 = @study_with_results.study_original_results.first
    sor2 = @study_with_results.study_original_results.last

    put :update, id: @study_with_results, study: { location: @study_with_results.location, original_id: @study_with_results.original_id, study_type_id: @study_with_results.study_type_id, results:
        [{ "rule_id"=>new_rule.id, "location"=>new_location, assessment_answers: [{question_id: 1, answer: 22}, {question_id: 2, answer: 2}]},
         {"study_original_result_id"=>sor1.id, "delete"=>"0", "rule_id"=>sor1.rule.id, "location"=>new_location, assessment_answers: [{question_id: "1", answer: "2"}, {question_id: "2", answer: "11"}]},
         {"study_original_result_id"=>sor2.id, "delete"=>"0","rule_id"=>sor2.rule.id, "location"=>new_location, assessment_answers: [{question_id: "1", answer: "2"}, {question_id: "2", answer: "2"}]}
        ]
    }

    s = Study.find(@study_with_results.id)

    assert_equal 3, s.study_original_results.count
    s.study_original_results.each do |sor|
      assert_equal new_location, sor.result.location
    end
    assert_redirected_to studies_path
  end

  test "should delete original result from study" do
    @study_with_results.reload
    @study_with_results = Study.find(@study_with_results.id)
    sor1 = @study_with_results.study_original_results.first
    sor2 = @study_with_results.study_original_results.last

    assert_difference "@study_with_results.study_original_results.count", -1 do

      put :update, id: @study_with_results, study: {
          location: @study_with_results.location, original_id: @study_with_results.original_id, study_type_id: @study_with_results.study_type_id,
          results:  [
                      {"study_original_result_id"=>sor1.id, "rule_id"=>sor1.rule.id, "location"=>sor1.result.location, "delete"=>"1", assessment_answers: [{question_id: "1", answer: "2"}, {question_id: "2", answer: "11"}]},
                      {"study_original_result_id"=>sor2.id, "rule_id"=>sor2.rule.id, "location"=>sor2.result.location, "delete"=>"0", assessment_answers: [{question_id: "1", answer: "2"}, {question_id: "2", answer: "11"}]}
                    ]
      }
    end
  end

  test "should destroy study" do
    assert_difference('Study.current.count', -1) do
      delete :destroy, id: @study
    end

    assert_redirected_to studies_path
  end
end
