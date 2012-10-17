class StudyOriginalResult < ActiveRecord::Base
  ##
  # Associations
  belongs_to :result
  belongs_to :study
  belongs_to :rule

  ##
  # Attributes
  attr_accessible :study_id, :rule_id, :result_id

end