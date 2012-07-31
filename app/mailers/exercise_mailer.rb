class ExerciseMailer < ActionMailer::Base
  default from: ActionMailer::Base.smtp_settings[:user_name]
  add_template_helper(ApplicationHelper)

  def notify_scorer(user, exercise)
    setup_email
    @user = user
    @exercise = exercise

    mail(to: @user.email,
         subject: @subject + "New Exercise #{@exercise.name} Assigned")
  end

  protected

  def setup_email
    @subject = "[#{DEFAULT_APP_NAME.downcase}#{'-development' if Rails.env == 'development'}] "
    @footer_html = "Change email settings here: <a href=\"#{SITE_URL}/settings\">#{SITE_URL}/settings</a>.<br /><br />".html_safe
    @footer_txt = "Change email settings here: #{SITE_URL}/settings."
  end
end
