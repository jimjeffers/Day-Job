class UserSessionsController < ApplicationController
  layout 'login'
  before_filter :require_no_user, :except => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  # user_sessions_controller.rb
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end
  
  def index
    redirect_to login_path
  end
end
