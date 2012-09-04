require 'test_helper'

class AssessmentResultTest < ActiveSupport::TestCase
  test "#question_info" do
    assessment = create(:assessment)

    assessment.assessment_results.each do |ar|
      assert_equal ar.question_info, Assessment::TYPES[assessment.assessment_type.to_sym][:questions][ar.question_id]
    end
  end

  test "#full_answer" do
    assessment = create(:assessment)

    assert_equal "20", assessment.assessment_results.first.full_answer
    assert_equal "A lot", assessment.assessment_results.last.full_answer
  end
end
