class ApplicationController < ActionController::Base
  layout "contour/layouts/application"

  protect_from_forgery

  def about

  end

  def parse_date(date_string)
    date_string.to_s.split('/').last.size == 2 ? Date.strptime(date_string, "%m/%d/%y") : Date.strptime(date_string, "%m/%d/%Y") rescue ""
  end

  def parse_search_terms(params)
    params.to_s.gsub(/[^0-9a-zA-Z]/, ' ').split(' ')
  end

  protected

  def check_system_admin
    redirect_to root_path, alert: "You do not have sufficient privileges to access that page." unless current_user.system_admin?
  end

end
