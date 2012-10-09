require 'test_helper'

class ExerciseTest < ActiveSupport::TestCase
  test "#percent_completed" do
    exercise = create(:exercise)
    total_result_count = exercise.all_studies.length * exercise.scorers.length
    result_count = 0

    exercise.scorers.each do |scorer|
      scorer.reliability_ids.where(:exercise_id => exercise.id).each do |rid|
        rid.result = create(:result)
        rid.save
        result_count += 1
        assert_equal ((result_count.to_f / total_result_count.to_f) * 100.0), exercise.percent_completed
      end
    end

    assert_equal 100.0, exercise.percent_completed

  end

  test "#completed?" do
    exercise = create(:exercise)
    scorer = exercise.scorers.first
    assert_equal false, exercise.completed?(scorer)

    scorer.reliability_ids.where(:exercise_id => exercise.id).each do |rid|
      rid.result = create(:result)
      rid.save
    end

    assert_equal true, exercise.completed?(scorer)
  end

  test "#all_completed?" do
    exercise = create(:exercise)
    assert_equal false, exercise.all_completed?

    exercise.scorers.each do |scorer|
      scorer.reliability_ids.where(:exercise_id => exercise.id).each do |rid|
        rid.result = create(:result)
        rid.save
      end
    end

    assert_equal true, exercise.all_completed?
  end

  test "#count_completed" do
    exercise = create(:exercise)
    assert_equal 0, exercise.count_completed

    exercise.scorers.each do |scorer|
      assert_difference "exercise.count_completed" do
        scorer.reliability_ids.where(:exercise_id => exercise.id).each do |rid|
          rid.result = create(:result)
          rid.save
        end
      end
    end

  end

  test "#finished_scorers and #pending_scorers" do
    exercise = create(:exercise)

    assert_equal exercise.scorers, exercise.pending_scorers
    assert_empty exercise.finished_scorers

    scorer = exercise.scorers.first

    scorer.exercise_reliability_ids(exercise).each do |r_id|
      r_id.result = create(:result)
      r_id.save
    end

    assert_equal [scorer], exercise.finished_scorers
    assert_equal exercise.finished_scorers.length + exercise.pending_scorers.length, exercise.scorers.length
  end

  test "#all_studies" do
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
      r_ids = scorer.reliability_ids.where(:exercise_id => exercise.id)
      assert_equal exercise.all_studies.length, r_ids.length
      ids += r_ids
    end

    assert_equal ids.uniq.count, ids.count
  end
end
