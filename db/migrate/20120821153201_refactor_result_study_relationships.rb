class RefactorResultStudyRelationships < ActiveRecord::Migration
  def up
    remove_column :results, :study_id
    remove_column :results, :exercise_id
    remove_column :results, :rule_id
    remove_column :results, :user_id
    add_column :results, :reliability_id_id, :integer
  end

  def down
    add_column :results, :study_id, :integer
    add_column :results, :exercise_id, :integer
    add_column :results, :rule_id, :integer
    add_column :results, :user_id, :integer
    remove_column :results, :reliability_id_id
  end
end
