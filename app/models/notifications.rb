class Notifications < ActionMailer::Base
  

  def invitation(invitation,sent_at = Time.now)
    subject    '[dayjob] Good grief, you\'ve been invited to work on something else...'
    recipients invitation.email
    from       'jim@sumocreations.com'
    sent_on    sent_at
    
    body       :project => invitation.project.name,
               :token   => invitation.token
  end
  
  def new_feature(author,feature,sent_at = Time.now)
    subject    "[#{feature.project.name}] #{author.login} has created a new feature."
    recipients feature.project.users.map { |u| u.email }.join(", ")
    from       'jim@sumocreations.com'
    sent_on    sent_at
    
    body       :project_name  => feature.project.name,
               :feature_name  => feature.name,
               :user_name     => author.login,
               :link          => feature_tasks_url(feature) 
  end
  
  def assigned_task(task,sent_at = Time.now)
    subject    "[#{task.feature.project.name}] #{task.delegator.login} has assigned you a new feature."
    recipients task.delegate.email
    from       'jim@sumocreations.com'
    sent_on    sent_at
    
    body       :project_name  => task.feature.project.name,
               :feature_name  => task.feature.name,
               :task_name     => task.name,
               :user_name     => task.delegator.login,
               :link          => feature_task_url(task.feature,task) 
  end

  def forgot_password(sent_at = Time.now)
    subject    'Notifications#forgot_password'
    recipients ''
    from       'jim@sumocreations.com'
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
