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
  attr_accessible :deleted, :exercise_id, :location, :rule_id, :study_id, :type, :user_id, :result_type

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

  private

end
