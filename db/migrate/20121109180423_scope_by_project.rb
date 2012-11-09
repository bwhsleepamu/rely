class ScopeByProject < ActiveRecord::Migration
  #
  #add project_id to Study, Group, Study Type, Scoring Rule, Exercise.
  #    change creator_id to owner_id in Project table
  #add ProjectScorer table
  #add ProjectManager table
  # remove project_group table
  def change
    add_column :studies, :project_id, :integer
    add_column :groups, :project_id, :integer
    add_column :study_types, :project_id, :integer
    add_column :rules, :project_id, :integer
    add_column :exercises, :project_id, :integer

    rename_column :projects, :creator_id, :owner_id

    create_table :project_scorer do |t|
      t.integer :user_id
      t.integer :project_id
    end

    create_table :project_manager do |t|
      t.integer :user_id
      t.integer :project_id
    end
  end
end
