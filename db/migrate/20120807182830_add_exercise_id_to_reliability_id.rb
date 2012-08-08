class AddExerciseIdToReliabilityId < ActiveRecord::Migration
  def change
    add_column :reliability_ids, :exercise_id, :integer
  end
end
