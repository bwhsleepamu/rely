class RefactorResultsAssessmentType < ActiveRecord::Migration
  def up
    remove_column :exercises, :assessment_type
    add_column :rules, :assessment_type, :string
    create_table :study_original_results do |t|
      t.integer :study_id
      t.integer :result_id
      t.integer :rule_id
      t.timestamps
    end
  end

  def down
    add_column :exercises, :assessment_type, :string
    add_column :rules, :assessment_type
    drop_table :study_original_results
  end
end
