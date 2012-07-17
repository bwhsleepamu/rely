class Study < ActiveRecord::Base
  ##
  # Associations
  has_many :groups, :through => :group_studies
  has_many :group_studies
  has_many :results
  belongs_to :study_type
  has_many :reliability_ids
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id, :conditions => { :deleted => false }

  ##
  # Attributes
  attr_accessible :deleted, :location, :original_id, :study_type_id

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
    self.original_id
  end

  private

end
