require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  test "set assessment results" do
    r_id = create(:reliability_id)
    assessment_answers_1 = {"1"=>"233", "2"=>"2"}
    assessment_answers_2 = {"1"=>"100", "2"=>"1"}

    result = build(:result, reliability_id_id: r_id.id, assessment_answers: assessment_answers_1)
    result.save

    assert_equal 2, result.assessment.assessment_results.length
    assert_equal assessment_answers_1["1"], result.assessment.assessment_results[0].answer

    result = Result.find(result.id)
    result.assessment_answers = assessment_answers_2
    result.save

    assert_equal 2, result.assessment.assessment_results.length
    assert_equal assessment_answers_2["1"], result.assessment.assessment_results[0].answer
  end

end
