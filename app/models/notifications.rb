class Notifications < ActionMailer::Base
  

  def invitation(invitation,sent_at = Time.now)
    subject    '[dayjob] Good grief, you\'ve been invited to work on something else...'
    recipients invitation.email
    from       'jim@sumocreations.com'
    sent_on    sent_at
    
    body       :project => invitation.project.name,
               :token   => invitation.token
  end

  def forgot_password(sent_at = Time.now)
    subject    'Notifications#forgot_password'
    recipients ''
    from       'jim@sumocreations.com'
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
