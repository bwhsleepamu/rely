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
  before_validation :generate_uuid

  ##
  # Database Settings

  ##
  # Scopes
  scope :current, conditions: { deleted: false }

  ##
  # Validations
  validates_uniqueness_of :unique_id
  validates_presence_of :study_id, :user_id, :exercise_id, :unique_id

  ##
  # Class Methods

  ##
  # Instance Methods
  def name
    self.unique_id
  end

  private

  def generate_uuid
    self[:unique_id] ||= UUID.new.generate
  end
end
