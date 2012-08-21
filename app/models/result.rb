class Result < ActiveRecord::Base
  ##
  # Associations
  belongs_to :reliability_id
  has_one :assessment, :conditions => { :deleted => false }

  ##
  # Attributes
  attr_accessible :location, :result_type, :assessment_answers, :reliability_id_id

  ##
  # Callbacks

  ##
  # Database Settings

  ##
  # Scopes
  scope :current, conditions: { deleted: false }

  ##
  # Validations
  validates_presence_of :reliability_id_id, :location, :result_type

  ##
  # Class Methods

  ##
  # Instance Methods
  def name
    "result_#{self.reliability_id.unique_id}"
  end

  def accessible?(user)
    user_id == user.id and ReliabilityId.where(user_id: user_id, exercise_id: exercise_id).empty? == false
  end

  def assessment_answers=(value)
    if value
      self.assessment = Assessment.new(assessment_type: reliability_id.exercise.assessment_type)
      value.each do |question_id, answer|
        self.assessment.assessment_results.build(question_id: question_id, answer: answer)
      end
    end
  end

  def destroy
    update_column :deleted, true
  end

  private

end
