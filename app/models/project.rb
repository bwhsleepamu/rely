class Project < ActiveRecord::Base
  ##
  # Associations
  has_many :groups, :through => :project_groups
  has_many :project_groups

  ##
  # Attributes
  attr_accessible :deleted, :description, :end_date, :name, :start_date

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
