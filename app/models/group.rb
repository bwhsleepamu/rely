class Group < ActiveRecord::Base
  ##
  # Associations
  has_many :projects, :through => :project_groups
  has_many :studies, :through => :group_studies
  has_many :project_groups
  has_many :group_studies
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id, :conditions => { :deleted => false }

  ##
  # Attributes
  attr_accessible :deleted, :description, :name, :study_ids

  ##
  # Callbacks

  ##
  # Database Settings

  ##
  # Scopes
  scope :current, conditions: { deleted: false }

  ##
  # Validations
  validates_presence_of :name

  ##
  # Class Methods

  ##
  # Instance Methods

  private

end
