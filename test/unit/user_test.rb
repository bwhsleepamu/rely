require 'test_helper'

SimpleCov.command_name "test:units"

class UserTest < ActiveSupport::TestCase
  fixtures :all

  test "should get reverse name" do
    assert_equal 'LastName, FirstName', users(:valid).reverse_name
  end

  test "should apply omniauth" do
    assert_not_nil users(:valid).apply_omniauth({ 'info' => {'email' => 'Email', 'first_name' => 'FirstName', 'last_name' => 'LastName' } })
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
end
