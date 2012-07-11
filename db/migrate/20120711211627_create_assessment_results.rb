class CreateAssessmentResults < ActiveRecord::Migration
  def change
    create_table :assessment_results do |t|
      t.integer :assessment_id
      t.integer :question_id
      t.text :answer
      t.boolean :deleted

      t.timestamps
    end
  end
end
