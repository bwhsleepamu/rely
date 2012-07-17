class AddCreatorToModels < ActiveRecord::Migration
  def change
    add_column :projects, :creator_id, :integer
    add_column :groups, :creator_id, :integer
    add_column :group_studies, :creator_id, :integer
    add_column :study_types, :creator_id, :integer
    add_column :studies, :creator_id, :integer
    add_column :rules, :creator_id, :integer
    add_column :project_groups, :creator_id, :integer
  end
end
