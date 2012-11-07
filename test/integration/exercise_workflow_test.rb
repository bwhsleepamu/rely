require 'test_helper'

SimpleCov.command_name "test:integration"

class ExerciseWorkflowTest < ActionDispatch::IntegrationTest
  def setup
    @user = login_admin
  end

  test "should get list of all exercises" do
    exercises = create_list(:exercise, 3, admin_id: @user.id)

    visit exercises_path
    assert find("tbody").has_selector?("tr", :count => Exercise.current.count)
  end

  test "should see completion status (user that completed) of exercises and date of completion" do
    exercises = create_list(:exercise, 3, admin_id: @user.id)
    my_exercise = exercises.first

    visit exercises_path
    show_page

    exercises.each do |exercise|
      tr = find("tr##{exercise.id}")
      assert tr.find("td.status").has_content?("0%")
    end

    click_on my_exercise.name

    assert page.has_content?("Finished Scorers")
    assert page.has_content?("Pending Scorers")

    pending = find("#pending_scorers")

    my_exercise.pending_scorers.each do |scorer|
      pending.has_content?(scorer.name)
    end

    my_exercise.reliability_ids.each do |r_id|
      r_id.result = create(:result)
      r_id.save
      my_exercise.check_completion
    end

    visit exercises_path

    my_exercise.reload
    show_page
    tr = find("tr##{my_exercise.id}")
    assert tr.find("td.status").has_content?("#{"%.1f" % my_exercise.percent_completed}%")
    assert_not_nil my_exercise.completed_at
    assert tr.find("td.completed_at").has_content?("Today at #{my_exercise.completed_at.strftime("%I:%M %p")}")

    click_on my_exercise.name

    finished = find("#finished_scorers")

    my_exercise.finished_scorers.each do |scorer|
      finished.has_content?(scorer.name)
    end

    show_page
  end

  test "should be able to get rescored results and original results for completed exercise" do
    exercises = create_list(:exercise, 3, admin_id: @user.id)
    my_exercise = exercises.first
    orig_results = []
    visit exercise_path(my_exercise)

    results = page.find("#results")

    my_exercise.all_studies.each do |study|
      assert results.has_content?(study.name)
      assert results.has_content?(study.original_id)
      new_orig_result = create(:result)

      study.study_original_results.create(study_id: study.id, result_id: new_orig_result.id, rule_id: my_exercise.rule.id)
      orig_results << new_orig_result
    end

    my_exercise.reliability_ids do |reliability_id|
      assert results.has_content?(reliability_id.unique_id)
      assert results.has_content?(reliability_id.user.name)
    end

    visit exercise_path(my_exercise)

    results = page.find("#results")

    show_page

    orig_results.each do |r|
      assert results.has_content?(r.location.to_s)
    end




  end

  test "should be able to launch an exercise" do
    pending "fails on travis ci - debug please"
    # Setup
    users = create_list(:user, 10)
    groups = create_list(:group_with_studies, 4)
    rule = create(:rule)
    name = "Test Exercise"
    description = "Description for a very vital exercise."
    reset_email

    # Creation
    visit exercises_path
    click_on "Create Exercise"


    fill_in "Name", :with => name
    fill_in "Description", :with => description
    select_from_chosen rule.name, :from => "Rule"
    groups.each do |group|
      select_from_chosen group.name, :from => "Groups"
    end
    users.each do |user|
      select_from_chosen user.name, :from => "Scorers"
    end

    click_button "Launch Exercise"

    # Show Page
    assert has_content?("Exercise was successfully launched."), page.html
    assert has_content?(@user.name)
    assert has_content?("Assigned")
    assert has_content?("Completed")
    assert has_content?(name)
    assert has_content?(description)
    groups.each do |group|
      assert has_content?(group.name)
    end
    users.each do |user|
      assert has_content?(user.name)
    end
    assert has_content?(rule.title)

    # Emails Sent
    assert_equal users.count, email_count
    recipients = email_recipients
    users.each do |user|
      assert recipients.include?(user.email)
    end
  end
end
