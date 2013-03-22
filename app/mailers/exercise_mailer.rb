class ExerciseMailer < ApplicationMailer
  default from: "#{DEFAULT_APP_NAME} <#{ActionMailer::Base.smtp_settings[:email]}>"
  add_template_helper(ApplicationHelper)

  def notify_scorer(user, exercise)
    setup_email
    @user = user
    @exercise = exercise

    mail(to: @user.email, subject: @subject + "New Exercise #{@exercise.name} Assigned")
  end
end
