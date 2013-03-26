class ExerciseGroup < ActiveRecord::Base
  belongs_to :group
  belongs_to :exercise

  # attr_accessible :exercise_id, :group_id
end
