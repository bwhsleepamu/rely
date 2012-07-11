class Rule < ActiveRecord::Base
  ##
  # Associations
  has_many :exercises
  has_many :results

  ##
  # Attributes
  attr_accessible :deleted, :procedure, :title

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
