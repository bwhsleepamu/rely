class ProjectAssociationFixes < ActiveRecord::Migration
  def change
    rename_table :project_manager, :project_managers
    rename_table :project_scorer, :project_scorers
    add_column(:project_managers, :created_at, :datetime)
    add_column(:project_scorers, :created_at, :datetime)
    add_column(:project_scorers, :updated_at, :datetime)
    add_column(:project_managers, :updated_at, :datetime)
  end
end
