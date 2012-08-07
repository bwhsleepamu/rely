class ReliabilityId < ActiveRecord::Base
  ##
  # Associations
  belongs_to :study
  belongs_to :user
  belongs_to :exercise

  ##
  # Attributes
  attr_accessible :deleted, :study_id, :unique_id, :user_id, :exercise_id

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
    self.unique_id
  end

  private

end
