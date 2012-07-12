class ReliabilityId < ActiveRecord::Base
  ##
  # Associations
  belongs_to :study

  ##
  # Attributes
  attr_accessible :deleted, :study_id, :unique_id

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
  def name
    self.unique_id
  end

  private

end
