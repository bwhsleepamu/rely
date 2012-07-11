class CreateExerciseUsers < ActiveRecord::Migration
  def change
    create_table :exercise_users do |t|
      t.integer :exercise_id
      t.integer :user_id

      t.timestamps
    end
  end
end
