require 'test_helper'

class ExerciseTest < ActiveSupport::TestCase
  test "#completed?" do
    exercise = create(:exercise)
    scorer = exercise.scorers.first
    assert_equal false, exercise.completed?(scorer)

    exercise.all_studies.each do |study|
      rid = study.reliability_id(scorer, exercise)
      rid.result = create(:result, reliability_id_id: rid.id)
    end

    assert_equal true, exercise.completed?(scorer)
  end

  test "#all_completed?" do
    exercise = create(:exercise)
    assert_equal false, exercise.all_completed?

    exercise.scorers.each do |scorer|
      exercise.all_studies.each do |study|
        rid = study.reliability_id(scorer, exercise)
        rid.result = create(:result, reliability_id_id: rid.id)
      end
    end

    assert_equal true, exercise.all_completed?
  end

  test "all_studies" do
    exercise = create(:exercise)
    study_count = 0
    exercise.groups.each do |group|
      group.studies.each do |study|
        study_count += 1
      end
    end
    assert_equal exercise.all_studies.count, study_count
  end

  test "should assign unique reliability ids to each study/scorer combo when exercise is launched" do
    exercise = create(:exercise)
    ids = []

    exercise.scorers.each do |scorer|
      exercise.all_studies.each do |study|
        r_id = study.reliability_id(scorer, exercise)
        assert_not_nil r_id
        ids << r_id
      end
    end

    assert_equal ids.uniq.count, ids.count
  end



end
