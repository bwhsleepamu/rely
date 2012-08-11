require 'test_helper'

class StudyTest < ActiveSupport::TestCase
  test "Study.find_by_reliability_id" do
    exercise = create(:exercise)
    exercise.scorers.each do |scorer|
      exercise.all_studies.each do |study|
        found_study = Study.find_by_reliability_id(study.reliability_id(scorer, exercise).unique_id)
        assert_equal false, found_study.nil?
        assert_equal found_study.id, study.id
      end
    end
  end

  test "#reliability_id" do

  end
end
