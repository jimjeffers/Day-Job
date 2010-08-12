class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :name
      t.float :hours
      t.string :aasm_state
      t.integer :completed_by
      t.date :completed_on
      t.integer :created_by
      t.integer :assigned_to
      t.references :feature
      t.timestamps
    end
    add_index :tasks, :feature_id
    add_index :tasks, :aasm_state
    add_index :tasks, :completed_by
    add_index :tasks, :created_by
    add_index :tasks, :assigned_to
  end

  def self.down
    remove_index :tasks, :assigned_to
    remove_index :tasks, :created_by
    remove_index :tasks, :completed_by
    remove_index :tasks, :aasm_state
    remove_index :tasks, :feature_id
    drop_table :tasks
  end
end
