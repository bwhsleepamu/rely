class ApplicationController < ActionController::Base
  layout "contour/layouts/application"

  protect_from_forgery

  def about

  end

  def parse_date(date_string)
    date_string.to_s.split('/').last.size == 2 ? Date.strptime(date_string, "%m/%d/%y") : Date.strptime(date_string, "%m/%d/%Y") rescue ""
  end

  def parse_search_terms(params)
    params.to_s.gsub(/[^0-9a-zA-Z]/, ' ') #.split(' ')
  end

  def render_if_exists(object)
    respond_to do |format|
      if object
        format.html # show.html.erb
        format.json { render json: object }
      else
        format.html { redirect_to root_path, error: "Sorry, the requested page could not be accessed. Please try again." }
        format.json { head :no_content }
      end
    end
  end

  protected

  def check_system_admin
    redirect_to root_path, alert: "You do not have sufficient privileges to access that page." unless current_user.system_admin?
  end

  def verify_project_exists
    redirect_to new_project_path, alert: "You must have at least one existing project to access that page." unless current_user.all_projects.present?
  end

end
