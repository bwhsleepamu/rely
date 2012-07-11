class StudyType < ActiveRecord::Base
  ##
  # Associations
  has_many :studies

  ##
  # Attributes
  attr_accessible :deleted, :description, :name

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
