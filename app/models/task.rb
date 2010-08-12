class Task < ActiveRecord::Base
  # --------------------------------------------------------------
  # Relationships
  
  belongs_to :feature,        :class_name => "Feature", :foreign_key => "feature_id"
  belongs_to :creator,        :class_name => "User",    :foreign_key => "created_by"
  belongs_to :delegate,       :class_name => "User",    :foreign_key => "assigned_to"
  belongs_to :user,           :class_name => "User",    :foreign_key => "completed_by"
  
  # --------------------------------------------------------------
  # Validations
  
  validates_numericality_of   :hours, :allow_blank => true
  validates_presence_of       :hours,           :if => :completed?
  validates_presence_of       :last_updated_by, :on => :create, :message => "can't be blank"
  
  # --------------------------------------------------------------
  # States and Transitions
  include AASM
  aasm_initial_state :pending

  aasm_state :pending
  aasm_state :completed, :enter => :completed_now!
  
  aasm_event :complete do
    transitions :to => :completed,  :from => [:pending], :guard => :has_time_entry?
  end
  
  # --------------------------------------------------------------
  # Scopes
  
  named_scope :for_project, lambda { |project| {
      :conditions => ['tasks.feature_id=features.id AND features.project_id=?',project.id],
      :include    => {:feature => :project } 
    }
  }
  named_scope :for_month, lambda { |time| {
      :conditions => ['tasks.completed_on BETWEEN ? and ?',date.last_month.end_of_month,date.next_month.beggining_of_month]
    }
  }
  named_scope :fifo,    :order => 'tasks.created_at ASC'
  named_scope :lifo,    :order => 'tasks.created_at DESC'
  named_scope :current, :order => 'tasks.updated_at DESC'
  
  # --------------------------------------------------------------
  # Callbacks
    
  # --------------------------------------------------------------
  # Class Methods
    
  # --------------------------------------------------------------
  # Instance Methods
  
  def has_time_entry?
    !self.hours.nil?
  end
  
  def completed_now!
    self.update_attributes({:completed_on => Time.now, :completed_by => self.last_updated_by})
  end
  
end