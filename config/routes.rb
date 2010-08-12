ActionController::Routing::Routes.draw do |map|
  
  # --------------------------------------------------------------
  # Project
  #
  # Projects are treated as a simple resource.
  
  map.resources :projects, 
                :member               => { :invite        => [:get],
                                           :suspend       => [:get],
                                           :send_invite   => [:post] },
                :shallow => true do |project|
    
    # --------------------------------------------------------------
    # Features
    #
    # Features are treated as a shallow nested resource with several member
    # and collection methods to make it easy to filter or change
    # the state of a feature's implementation.

    project.resources  :features, 
                       :member       => { :complete      => [:get, :post],
                                          :undo          => [:get, :post]} do |feature|
    
      # --------------------------------------------------------------
      # Tasks
      #
      # Tasks are treated as a nested resource to features with several 
      # member and collection methods to make it easy to filter or change
      # the state of a state from pending to complete.

      feature.resources  :tasks, 
                         :member       => { :enter_time      => [:get, :post], # Presents time entry form.
                                            :complete        => [:post],       # Performs time entry.
                                            :delegate        => [:get, :post], # Presents delegation form.
                                            :assign          => [:post],       # Performs delegation.
                                            :undo            => [:get]},       # Reverts time entry.
                        :shallow => false
    end
  end
  
  # --------------------------------------------------------------
  # Users
  #
  # A user is treated like a resource but we've added some named
  # routes as a convenience to easily access the signup and account
  # pages.
  
  map.resources     :users
  map.signup        'signup',         :controller => :users,            :action => :new
  map.account       'account',        :controller => :users,            :action => :edit
  
  # --------------------------------------------------------------
  # User Sessions
  #
  # We treat user sessions as a simple resource but have added some
  # named routes as convenience methods to easily access the login
  # and logout pages.
  
  map.resources     :user_sessions
  map.login         'login',          :controller => :user_sessions,    :action => :new
  map.logout        'logout',         :controller => :user_sessions,    :action => :destroy
  
  # --------------------------------------------------------------
  # Invitations
  #
  # Users need to be able to accept invitations from an encrypted
  # token sent via email.
  
  map.accept_invite 'accept_invite/:token',  
                                      :controller => :invitations,      :action => :accept      
  
  # --------------------------------------------------------------
  # Defaults
  #
  # When all else fails default to rails's default routing style.
  
  map.connect       ':controller/:action/:id'
  map.connect       ':controller/:action/:id.:format'
  
  # --------------------------------------------------------------
  # Root
  #
  # The root currently points users to the login page. This will 
  # likely be updated to a marketing page to demo the product.
  
  map.root                            :controller => :user_sessions,    :action => :new
  
end