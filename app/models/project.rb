class Project < ActiveRecord::Base
  # --------------------------------------------------------------
  # Relationships
  
  has_many :features
  has_many :users, :through => :invitations, :conditions => ["invitations.aasm_state=?","accepted"]
  has_many :admins, :source => :project, :through => :invitations, :conditions => ["invitations.aasm_state=? AND (invitations.admin=? OR invitations.owner=?)","accepted",1,1]
  has_many :invitations

  # --------------------------------------------------------------
  # Validations
    
  # --------------------------------------------------------------
  # States and Transitions
  #
  # A project can be placed in one of four states:
  #
  #   1. New        (untouched, it can never return to this state)
  #   2. Active     (in progress)
  #   3. Completed  (done and essentially archived)
  #   4. On Hold    (a suspended state)
  
  include AASM
  aasm_initial_state :new

  aasm_state :new
  aasm_state :active
  aasm_state :completed
  aasm_state :on_hold
  
  aasm_event :start do
    transitions :to => :active, :from => [:new, :on_hold]
  end
  
  aasm_event :complete do
    transitions :to => :completed, :from => [:active]
  end
  
  aasm_event :suspend do
    transitions :to => :on_hold, :from => [:active, :new]
  end
    
  # --------------------------------------------------------------
  # Scopes
  
  named_scope :active, :conditions => ["projects.aasm_state=? OR projects.aasm_state=?","new","active"]
  
  # --------------------------------------------------------------
  # Callbacks
    
  # --------------------------------------------------------------
  # Class Methods
    
  # --------------------------------------------------------------
  # Instance Methods
  
  def set_owner(user)
    Invitation.create!(:project => self, :user => user, :owner => 1, :admin => 1).accept!
  end
  
end
