class InvitationsController < ApplicationController
  layout "login"
  
  def accept
    current_user_session.destroy if current_user_session
    @invitation = Invitation.find_by_token_and_aasm_state(params[:token],'pending')
    @user = User.new
    @user_session = UserSession.new
    if @invitation.nil?
      redirect_to(signup_path, :notice => "The invitation you received is not valid.")
    else
      render :action => 'accept_only_login' unless User.find_by_email(@invitation.email).nil?
    end
  end

end
