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
  validates_presence_of :study_id, :unless => Proc.new { |a| a.study }
  validates_presence_of :rule_id, :unless => Proc.new { |a| a.rule }
  validates_presence_of :result_id, :unless => Proc.new { |a| a.result }
  validates_uniqueness_of :rule_id, :scope => :study_id, :unless => Proc.new {|a| a.study_id.blank? }
  validates_associated :result

  #def destroy
  #  update_column :deleted, true
  #end

end