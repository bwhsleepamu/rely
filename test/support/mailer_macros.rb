module MailerMacros
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def reset_email
    ActionMailer::Base.deliveries = []
  end

  def email_count
    ActionMailer::Base.deliveries.count
  end

  def email_recipients
    ActionMailer::Base.deliveries.map {|d| d.to[0] }
  end
end