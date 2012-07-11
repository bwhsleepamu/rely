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
  attr_accessible :assessment_id, :deleted, :exercise_id, :location, :rule_id, :study_id, :type, :user_id

  ##
  # Callbacks

  ##
  # Database Settings

  ##
  # Scopes
  scope :current, conditions: { }

  ##
  # Validations

  ##
  # Class Methods

  ##
  # Instance Methods

  private

end
