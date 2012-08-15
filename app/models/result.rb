class Result < ActiveRecord::Base
  ##
  # Associations
  belongs_to :user
  belongs_to :exercise
  belongs_to :study
  belongs_to :rule
  has_one :assessment

  ##
  # Attributes
  attr_accessible :exercise_id, :location, :rule_id, :study_id, :type, :user_id, :result_type, :assessment_answers

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
    "#{self.study} #{self.user} #{self.result_type}"
  end

  def accessible?(user)
    user_id == user.id and ReliabilityId.where(user_id: user_id, exercise_id: exercise_id).empty? == false
  end

  def assessment_answers=(value)
    if value
      self.assessment = Assessment.new(assessment_type: self.exercise.assessment_type)
      value.each do |question_id, answer|
        self.assessment.assessment_results.build(question_id: question_id, answer: answer)
      end
    end
  end

  private

end
