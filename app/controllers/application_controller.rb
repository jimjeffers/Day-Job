# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # --------------------------------------------------------------
  # Helper Methods
  #
  # The current user session and current user methods are set
  # as helper methods so that we can provide alternate renderings
  # in our layout code depending on the current viewers status.
  
  helper_method :current_user_session, :current_user
  
  # --------------------------------------------------------------
  # Parameter Filtering
  #
  # We're filtering any password or password confirmation
  # fields in our logs. This is to prevent sensitive user account
  # data from becoming jeopardized if our logs somehow are obtained
  # by malicious parties.
  
  filter_parameter_logging :password, :password_confirmation

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to projects_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
    def redirect_back_or_to(path)
      begin
        redirect_to :back
      rescue
        redirect_to path
      end
    end
    
    def time_for_project(project)
      if @project.nil?
        @month_hours, @week_hours, @day_hours = 0, 0 ,0
      else
        @month_hours  = Task.for_project(project).by_month(Time.now, :field => :completed_on).sum(:hours)
        @week_hours   = Task.for_project(project).by_current_work_week(:field => :completed_on).sum(:hours)
        @day_hours    = Task.for_project(project).by_day(Time.now, :field => :completed_on).sum(:hours)
      end
    end
end