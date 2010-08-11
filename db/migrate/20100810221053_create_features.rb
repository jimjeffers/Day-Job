class CreateFeatures < ActiveRecord::Migration
  def self.up
    create_table :features do |t|
      t.string :name
      t.string :aasm_state
      t.text :description
      t.integer :created_by
      t.references :project
      t.timestamps
    end
    add_index :features, :project_id
    add_index :features, :aasm_state
  end

  def self.down
    remove_index :features, :aasm_state
    remove_index :features, :project_id
    drop_table :features
  end
end
