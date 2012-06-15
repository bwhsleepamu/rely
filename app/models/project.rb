class Project < ActiveRecord::Base
  ##
  # Associations
  belongs_to :user

  ##
  # Attributes
  attr_accessible :deleted, :description, :end_date, :name, :start_date, :user_id

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
