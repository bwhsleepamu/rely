class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.integer :result_id
      t.string :assessment_type
      t.boolean :deleted

      t.timestamps
    end
  end
end
