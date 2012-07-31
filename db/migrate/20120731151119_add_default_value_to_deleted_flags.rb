class AddDefaultValueToDeletedFlags < ActiveRecord::Migration
  def up
    change_column :assessment_results, :deleted, :boolean, :null => false, :default => false
    change_column :assessments, :deleted, :boolean, :null => false, :default => false
    change_column :exercises, :deleted, :boolean, :null => false, :default => false
    change_column :groups, :deleted, :boolean, :null => false, :default => false
    change_column :reliability_ids, :deleted, :boolean, :null => false, :default => false
    change_column :results, :deleted, :boolean, :null => false, :default => false
    change_column :rules, :deleted, :boolean, :null => false, :default => false
    change_column :studies, :deleted, :boolean, :null => false, :default => false
    change_column :study_types, :deleted, :boolean, :null => false, :default => false
  end
end
