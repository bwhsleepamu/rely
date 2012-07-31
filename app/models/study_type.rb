class StudyType < ActiveRecord::Base
  ##
  # Associations
  has_many :studies
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id, :conditions => { :deleted => false }


  ##
  # Attributes
  attr_accessible :deleted, :description, :name

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
  validates_uniqueness_of :name

  ##
  # Class Methods

  ##
  # Instance Methods

  private

end
