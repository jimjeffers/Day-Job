class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.string      :aasm_state
      t.string      :token
      t.string      :email
      t.integer     :admin,         :default => 0
      t.integer     :owner,         :default => 0
      t.integer     :created_by
      t.references  :project
      t.references  :user
      t.timestamps
    end
    add_index :invitations, :user_id
    add_index :invitations, :project_id
    add_index :invitations, :token
    add_index :invitations, :created_by
  end

  def self.down
    remove_index :invitations, :created_by
    remove_index :invitations, :token
    remove_index :invitations, :project_id
    remove_index :invitations, :user_id
    drop_table :invitations
  end
end