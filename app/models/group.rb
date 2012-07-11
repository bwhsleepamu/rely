class Group < ActiveRecord::Base
  ##
  # Associations
  has_many :projects, :through => :project_groups
  has_many :studies, :through => :group_studies
  has_many :project_groups
  has_many :group_studies

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
