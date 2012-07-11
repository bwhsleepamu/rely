class Study < ActiveRecord::Base
  ##
  # Associations
  has_many :groups, :through => :group_studies
  has_many :group_studies
  has_many :results
  belongs_to :study_type
  has_many :reliability_ids

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

  private

end
