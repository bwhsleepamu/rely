module ExercisesHelper
  def completed_percent(exercise, user = nil)
    per = user.present? ? exercise.completion_status_percent(user) : exercise.percent_completed

    "#{"%.1f" % per}%"
  end
end
