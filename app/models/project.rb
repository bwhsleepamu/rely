class Project < ActiveRecord::Base
  ##
  # Associations
  has_many :groups, :through => :project_groups
  has_many :project_groups
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id, :conditions => { :deleted => false }

  ##
  # Attributes
  attr_accessible :deleted, :description, :end_date, :name, :start_date, :group_ids

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

  private

end
