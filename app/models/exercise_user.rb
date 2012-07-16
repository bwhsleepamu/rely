class ExerciseUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise

  attr_accessible :exercise_id, :user_id
end
