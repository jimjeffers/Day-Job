class Project < ActiveRecord::Base
  # --------------------------------------------------------------
  # Relationships

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
end
