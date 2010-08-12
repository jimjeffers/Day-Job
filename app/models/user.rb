class User < ActiveRecord::Base
  
  # --------------------------------------------------------------
  # Authentication
  #
  # We're implementing user authentication with the authlogic 
  # gem. Presently I'm using nearly all of the optional magic_column
  # fields in the database with the exception of the 'email' field.
  # Authentication currently works with a login and username. 
  # Nothing additional is required at this point in time.
  
  acts_as_authentic
  
  # --------------------------------------------------------------
  # Relationships
  #
  # A user has many tasks that he or she has completed or those
  # that have been assigned to them.
  
  has_many :categories
  
  has_many :invitations
  
  has_many :projects, 
           :through => :invitations, 
           :conditions => ["invitations.aasm_state=?","accepted"]
  
  has_many :admin_projects, 
           :source => :project, 
           :through => :invitations, 
           :conditions => ["invitations.aasm_state=? AND (invitations.admin=? OR invitations.owner=?)","accepted",1,1]
  
  has_many :tasks, 
           :class_name => "Task", 
           :foreign_key => "completed_by"
  
  has_many :assigned_tasks, 
           :class_name => "Task", 
           :foreign_key => "assigned_to",
           :conditions => ["tasks.aasm_state!=?","completed"]
  
  # --------------------------------------------------------------
  # Validations
  
  # --------------------------------------------------------------
  # States and Transitions
  
  # --------------------------------------------------------------
  # Scopes
  
  # --------------------------------------------------------------
  # Callbacks
  
  # --------------------------------------------------------------
  # Class Methods
  
  # --------------------------------------------------------------
  # Instance Methods
  
end