require 'test_helper'

SimpleCov.command_name "test:units"

class UserTest < ActiveSupport::TestCase
  #fixtures :all
  
  test "should get reverse name" do
    user = create(:user)
    assert_equal "#{user.last_name}, #{user.first_name}", user.reverse_name
  end

  test "should apply omniauth" do
    user = create(:user)
    assert_not_nil user.apply_omniauth({ 'info' => {'email' => 'Email', 'first_name' => 'FirstName', 'last_name' => 'LastName' } })
  end

  test "#exercise_reliability_ids should return reliability id object for given exercise" do
    exercise = create(:exercise)
    scorer = exercise.scorers.first

    assert_not_nil scorer.exercise_reliability_ids(exercise)
    assert_equal scorer.reliability_ids.where(:exercise_id => exercise.id), scorer.exercise_reliability_ids(exercise)
  end

  test "#exercise_reliability_ids should return nil if no associated reliability id" do
    exercise = create(:exercise)
    scorer = create(:user)

    assert_empty scorer.exercise_reliability_ids(exercise)
  end

  test "#all_projects" do
    manager = create(:user)
    create(:project, owner: manager)
    assert_equal 1, manager.all_projects.length, manager.all_projects.to_a

    create_list :project, 2
    assert_difference("manager.all_projects.length") do
      p = create(:project)
      p.managers << manager
      p.save
    end
  end

  test "#all_exercises" do
    r = setup_result_tests
    assert r[:manager].all_exercises.length == 1

  end

  test "#all_results" do
    r = setup_result_tests
    assert_equal 0, r[:manager].all_results.length
    assert r[:scorer].all_results.present?
    assert_equal r[:count][:exercise], r[:scorer].all_results.length
  end

  test "#all_exercise_results" do
    r = setup_result_tests
    assert_equal 0, r[:scorer].all_exercise_results.length
    assert_equal r[:count][:rid], r[:manager].all_exercise_results.length
  end

  test "#all_original_results" do
    r = setup_result_tests
    assert_equal 0, r[:scorer].all_original_results.length
    assert r[:manager].all_original_results.length.present?
    assert_equal r[:count][:original], r[:manager].all_original_results.length
  end

  test "#all_viewable_results" do
    r = setup_result_tests
    assert_equal r[:count][:exercise], r[:scorer].all_viewable_results.length
    assert_equal r[:count][:total], r[:manager].all_viewable_results.length

  end

  def setup_result_tests
    p = create(:project)
    e = create(:exercise, existing_project_id: p.id)
    result_count = {total: 0, exercise: 0, rid: 0, original: 0}

    scorer = e.scorers.first

    e.reliability_ids.each do |rid|
      rid.result = build(:result)
      rid.save
      result_count[:total] += 1
      result_count[:rid] += 1
      result_count[:exercise] += 1 if rid.user == scorer
    end

    p.studies.each do |s|
      p.rules.each do |r|
        sor = StudyOriginalResult.new
        sor.rule = r
        sor.result = build(:result)
        result_count[:total] += 1
        result_count[:original] += 1
        s.study_original_results << sor
        s.save
      end
    end

    assert e.project == p

    {manager: p.managers.first, scorer: scorer, count: result_count}
  end
end
