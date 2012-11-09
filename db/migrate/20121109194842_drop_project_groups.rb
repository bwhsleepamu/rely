class DropProjectGroups < ActiveRecord::Migration
  def up
    drop_table :project_groups
  end

  def down
    create_table :project_groups do |t|
      t.integer :project_id
      t.integer :group_id

      t.timestamps
    end
  end
end
