class StudyOriginalResult < ActiveRecord::Base
  ##
  # Associations
  belongs_to :result
  belongs_to :study
  belongs_to :rule
end