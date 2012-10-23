class StudyOriginalResult < ActiveRecord::Base
  ##
  # Associations
  belongs_to :result
  belongs_to :study
  belongs_to :rule

  ##
  # Attributes
  attr_accessible :study_id, :rule_id, :result_id

  ##
  # Validations
  validates_uniqueness_of :rule_id, :scope => :study_id

  #def destroy
  #  update_column :deleted, true
  #end

end