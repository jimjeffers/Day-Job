class Invitation < ActiveRecord::Base
  # --------------------------------------------------------------
  # Relationships
  
  belongs_to :project
  belongs_to :user
  
  # --------------------------------------------------------------
  # Validations
  
  validates_presence_of :project
    
  # --------------------------------------------------------------
  # States and Transitions
  
  include AASM
  aasm_initial_state :pending

  aasm_state :pending
  aasm_state :accepted
  
  aasm_event :accept do
    transitions :to => :accepted, :from => [:pending]
  end
  
  # --------------------------------------------------------------
  # Scopes
  
  named_scope :pending,   :conditions => ["invitations.aasm_state=?",'pending']
  named_scope :accepted,  :conditions => ["invitations.aasm_state=?",'accepted']
    
  # --------------------------------------------------------------
  # Callbacks
  
  # --------------------------------------------------------------
  # Class Methods
  
  class << self
    def create_with_email_for_project_from_user(email,project,user)
      self.create(  :created_by   => user, 
                    :email        => email,
                    :project      => project, 
                    :token        => Digest::SHA1.hexdigest([Time.now.to_s,email,user.login].join('--')) )
    end
  end
  
  # --------------------------------------------------------------
  # Instance Methods
  
  def accept_on_behalf_of_user!(user)
    if self.pending?
      self.update_attribute(:user_id,user.id)
      self.accept!
    end
  end
  
  def created_by=(user)
    write_attribute(:created_by, user.id) unless user.nil? or user.id.nil?
  end
  
  def created_by
    user_id = read_attribute(:created_by)
    User.find(user_id) unless user_id.nil?
  end
  
end
