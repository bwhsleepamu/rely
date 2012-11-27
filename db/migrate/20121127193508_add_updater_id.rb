class AddUpdaterId < ActiveRecord::Migration
  def change
    add_column :studies, :updater_id, :integer
    add_column :rules, :updater_id, :integer
    add_column :groups, :updater_id, :integer
    add_column :exercises, :updater_id, :integer
    add_column :study_types, :updater_id, :integer
  end
end
