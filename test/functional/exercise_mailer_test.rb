require 'test_helper'

class ExerciseMailerTest < ActionMailer::TestCase
  test "notify scorer of new exercise" do
    exercise = create(:exercise)
    user = users(:valid)

    # Send the email, then test that it got queued
    assert ActionMailer::Base.deliveries.empty?
    email = ExerciseMailer.notify_scorer(user, exercise).deliver
    assert !ActionMailer::Base.deliveries.empty?

    # Test the body of the sent email contains what we expect it to
    assert_equal [user.email], email.to
    assert_equal "[#{DEFAULT_APP_NAME.downcase}] New Exercise #{exercise.name} Assigned", email.subject
    assert_match(/#{exercise.name}/, email.encoded)

  end

end