class AddLastUpdatedByToTasks < ActiveRecord::Migration
  def self.up
    add_column    :tasks, :last_updated_by, :integer
    add_index     :tasks, :last_updated_by
  end

  def self.down
    remove_index  :tasks, :last_updated_by
    remove_column :tasks, :last_updated_by
  end
end
