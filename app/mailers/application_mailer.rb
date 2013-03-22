class ApplicationMailer < ActionMailer::Base
  
  protected

  def setup_email
    @subject = "[#{DEFAULT_APP_NAME.downcase}#{'-development' if Rails.env == 'development'}] "
    @footer_html = "Change email settings here: <a href=\"#{SITE_URL}/settings\">#{SITE_URL}/settings</a>.<br /><br />".html_safe
    @footer_txt = "Change email settings here: #{SITE_URL}/settings."
  end
end
