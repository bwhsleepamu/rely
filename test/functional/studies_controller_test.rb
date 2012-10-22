require 'test_helper'

class StudiesControllerTest < ActionController::TestCase
  setup do
    @study = create(:study)
    @template = build(:study)
    @study_with_results = create(:study_with_original_results, result_count: 2)
    @current_user = login(users(:admin))
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:studies)
  end

  test "should get paginated index" do
    get :index, format: 'js'
    assert_not_nil assigns(:studies)
    assert_template 'index'
  end


  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create study" do
    assert_difference('Study.count') do
      post :create, study: { location: @template.location, original_id: @template.original_id, study_type_id: @study.study_type_id }
    end

    assert_redirected_to study_path(assigns(:study))
  end

  test "should create study with original results" do
    rule1 = create(:rule)
    rule2 = create(:rule)

    assert_difference('Study.count') do
      post :create, study: { location: @template.location, original_id: @template.original_id, study_type_id: @study.study_type_id, results:
          [{ rule_id: rule1.id, location: "/best/place/ever/1",  assessment_answers: {:assessment_type => "{:value=>\"paradox\"}", "1" => "2", "2" => "11" }  }, {rule_id: rule2.id, location: "/best/place/ever/2", assessment_answers: {:assessment_type => "{:value=>\"paradox\"}", "1" => "1", "2" => "1" }   }]
      }
    end

    assert_equal 2, assigns(:study).original_results.count
    assert_redirected_to study_path(assigns(:study))
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
    assert_redirected_to study_path(assigns(:study))
  end

  test "should update study with original results" do
    new_rule = create(:rule)
    new_location = "new_location/up/in/here"
    assert_equal 2, @study_with_results.study_original_results.count

    sor1 = @study_with_results.study_original_results.first
    sor2 = @study_with_results.study_original_results.last

    put :update, id: @study_with_results, study: { location: @study_with_results.location, original_id: @study_with_results.original_id, study_type_id: @study_with_results.study_type_id, results:
        [{ "study_id"=> @study_with_results.id, "rule_id"=>new_rule.id, "location"=>new_location, "assessment_answers"=>{"assessment_type"=>"{:value=>\"paradox\"}", "1"=>"22", "2"=>"2"}},
         {"study_original_result_id"=>sor1.id, "study_id"=>@study_with_results.id, "rule_id"=>sor1.rule.id, "location"=>new_location, "assessment_answers"=>{"assessment_type"=>"{:value=>\"paradox\"}", "1"=>"2", "2"=>"2"}},
         {"study_original_result_id"=>sor2.id, "study_id"=>@study_with_results.id, "rule_id"=>sor2.rule.id, "location"=>new_location, "assessment_answers"=>{"assessment_type"=>"{:value=>\"paradox\"}", "1"=>"2", "2"=>"2"}}
        ]
    }

    s = Study.find(@study_with_results.id)

    assert_equal 3, s.study_original_results.count
    s.study_original_results.each do |sor|
      assert_equal new_location, sor.result.location
    end
    assert_redirected_to study_path(assigns(:study))
  end

  test "should destroy study" do
    assert_difference('Study.current.count', -1) do
      delete :destroy, id: @study
    end

    assert_redirected_to studies_path
  end
end
