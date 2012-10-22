require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  test "set assessment results" do
    r_id = create(:reliability_id)
    assessment_answers_1 = {"1"=>"233", "2"=>"2", :assessment_type => r_id.exercise.rule.assessment_type}
    assessment_answers_2 = {"1"=>"100", "2"=>"1"}

    result = build(:result, assessment_answers: assessment_answers_1)
    result.save

    assert_equal 2, result.assessment.assessment_results.length
    assert_equal assessment_answers_1["1"], result.assessment.assessment_results[0].answer

    result = Result.find(result.id)
    result.assessment_answers = assessment_answers_2
    result.save

    assert_equal 2, result.assessment.assessment_results.length
    assert_equal assessment_answers_2["1"], result.assessment.assessment_results[0].answer
  end

  test "study" do
    pending
  end

  test "rule" do
    rule = create(:rule)
    study = create(:study)
    exercise = create(:exercise)
    r_id = exercise.reliability_ids.first

    # non-saved
    result = Result.new
    result.reliability_id = r_id
    assert_equal result.rule, exercise.rule

    result = Result.new
    result.study_original_result = StudyOriginalResult.new(study_id: study.id, rule_id: rule.id)
    assert_equal result.rule, rule
  end


end
