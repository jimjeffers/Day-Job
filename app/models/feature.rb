class Feature < ActiveRecord::Base
  # --------------------------------------------------------------
  # Relationships
  
  belongs_to :project

  # --------------------------------------------------------------
  # Validations
  
  validates_presence_of :project, :name
  
  # --------------------------------------------------------------
  # States and Transitions
  #
  # A feature can be placed in one of four states:
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
    transitions :to => :on_hold, :from => [:active]
  end
  
  # --------------------------------------------------------------
  # Scopes
    
  # --------------------------------------------------------------
  # Callbacks
    
  # --------------------------------------------------------------
  # Class Methods
    
  # --------------------------------------------------------------
  # Instance Methods
  
  def created_by=(user)
    write_attribute(:created_by, user.id) unless user.nil? or user.id.nil?
  end
  
  def created_by
    user_id = read_attribute(:created_by)
    User.find(user_id) unless user_id.nil?
  end
  
end
