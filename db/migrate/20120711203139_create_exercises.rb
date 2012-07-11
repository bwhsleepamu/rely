class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.integer :admin_id
      t.integer :rule_id
      t.string :name
      t.text :description
      t.string :assessment_type
      t.datetime :assigned_at
      t.datetime :completed_at
      t.boolean :deleted

      t.timestamps
    end
  end
end
