require 'test_helper'

class StudyTest < ActiveSupport::TestCase
  test "#group" do
    exercise = create(:exercise)
    group = exercise.groups.first
    study = group.studies.first
    r_id = exercise.reliability_ids.where(:study_id => study.id).first

    assert_not_nil study.group(r_id)
    assert_equal group, study.group(r_id)
  end
end
