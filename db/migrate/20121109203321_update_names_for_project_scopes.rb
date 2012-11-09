class UpdateNamesForProjectScopes < ActiveRecord::Migration
  def change
    rename_table :exercise_users, :exercise_scorers
    rename_column :exercises, :admin_id, :owner_id
  end
end
