class UsersController < ApplicationController
  layout 'login'
  before_filter :require_user, :only => [:update, :edit]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      if params[:token] and !(invitation = Invitation.find_by_token(params[:token])).nil?
        invitation.accept_on_behalf_of_user!(@user)
      end
      flash[:notice] = "Registration successful."
      redirect_to projects_path
    else
      render :action => 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated profile."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
  
  def index
    redirect_to root_url
  end
  
end
