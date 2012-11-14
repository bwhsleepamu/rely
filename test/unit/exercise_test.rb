require 'test_helper'

class ExerciseTest < ActiveSupport::TestCase
  test "scopes" do
    # test owner, scorer, manager, project
    project = create(:project)

    create_list(:exercise, 5, existing_project_id: project.id)

    e1 = create(:exercise)
    e2 = create(:exercise)

    scorer = e1.scorers.first
    owner = e2.owner
    manager = e2.project.managers.first
    project = e1.project

    scorer_scope = Exercise.current.with_scorer(scorer)
    owner_scope = Exercise.current.with_owner(owner)
    manager_scope = Exercise.current.with_manager(manager)
    project_scope = Exercise.current.with_project(project)

    l = 1
    assert (scorer_scope.length == l and owner_scope.length == l and manager_scope.length == l and project_scope.length == l), "s: #{scorer_scope.length} o: #{owner_scope.length} m: #{manager_scope.length} p: #{project_scope.length}"
    assert (scorer_scope.first == e1 and project_scope.first == e1)
    assert (owner_scope.first == e2 and manager_scope.first == e2)

    e3 = create(:exercise, existing_project_id: e1.project.id)
    e3.scorers << scorer unless e3.scorers.include?(scorer)
    e3.owner = owner
    e3.project.managers << manager
    e3.save

    scorer_scope = Exercise.current.with_scorer(scorer)
    owner_scope = Exercise.current.with_owner(owner)
    manager_scope = Exercise.current.with_manager(manager)
    project_scope = Exercise.current.with_project(project)

    l = 2
    assert (scorer_scope.length == l and owner_scope.length == l and manager_scope.length == (l+1) and project_scope.length == l), "s: #{scorer_scope.length} o: #{owner_scope.length} m: #{manager_scope.length} p: #{project_scope.length}"
  end

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
