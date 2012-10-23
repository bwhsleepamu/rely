class AssessmentResult < ActiveRecord::Base
  ##
  # Associations
  belongs_to :assessment

  ##
  # Attributes
  attr_accessible :answer, :assessment_id, :question_id

  ##
  # Callbacks

  ##
  # Database Settings

  ##
  # Scopes
  scope :current, conditions: { deleted: false }

  ##
  # Validations

  ##
  # Class Methods

  ##
  # Instance Methods
  def name
    self.assessment_id
  end

  def destroy
    update_column :deleted, true
  end

  def full_answer
    if question_info.has_key?(:options)
      question_info[:options][answer.to_i]
    else
      answer
    end
  end

  def question_info
    MY_LOG.info "HEHRHEHEH: #{assessment.assessment_type.to_sym}"
    Assessment::TYPES[assessment.assessment_type.to_sym][:questions][question_id]
  end

  private

end
