class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :user_id
      t.integer :study_id
      t.integer :exercise_id
      t.integer :rule_id
      t.string :result_type
      t.string :location
      t.boolean :deleted

      t.timestamps
    end
  end
end
