class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.string :aasm_state
      t.timestamps
    end
    add_index :projects, :aasm_state
  end

  def self.down
    remove_index :projects, :aasm_state
    drop_table :projects
  end
end
