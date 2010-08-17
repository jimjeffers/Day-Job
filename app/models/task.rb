class Task < ActiveRecord::Base
  # --------------------------------------------------------------
  # Relationships
  
  belongs_to :feature,        :class_name => "Feature", :foreign_key => "feature_id"
  belongs_to :creator,        :class_name => "User",    :foreign_key => "created_by"
  belongs_to :delegator,      :class_name => "User",    :foreign_key => "last_updated_by"
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
  named_scope :fifo,    :order => 'tasks.created_at ASC'
  named_scope :lifo,    :order => 'tasks.created_at DESC'
  named_scope :current, :order => 'tasks.updated_at DESC'
  
  # --------------------------------------------------------------
  # Callbacks
  
  def after_save
    Notifications.deliver_assigned_task(self) unless self.delegate.nil? or self.completed? or self.delegator == self.delegate
  end
  
  # --------------------------------------------------------------
  # Class Methods
  
  # --------------------------------------------------------------
  # Instance Methods
  
  def has_time_entry?
    !self.hours.nil?
  end
  
  def completed_now!
    self.update_attributes({:completed_on => Time.now, :completed_by => self.last_updated_by})
    Notifications.deliver_completed_task(self)
  end
  
  def was_not_completed_by(user)
    self.user.nil? || self.user != user
  end
  
end