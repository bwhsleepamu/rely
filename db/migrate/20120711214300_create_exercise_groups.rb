class CreateExerciseGroups < ActiveRecord::Migration
  def change
    create_table :exercise_groups do |t|
      t.integer :exercise_id
      t.integer :group_id

      t.timestamps
    end
  end
end
