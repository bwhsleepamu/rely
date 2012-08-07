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
  scope :current, conditions: { deleted: false }

  ##
  # Validations
  validates_presence_of :study_type, :location, :original_id
  validates_uniqueness_of :original_id

  ##
  # Class Methods

  ##
  # Instance Methods
  def name
    self.original_id
  end

  def long_name
    "#{self.original_id} #{self.location}"
  end

  def to_s
    "id: #{self.original_id} location: #{self.location}"
  end

  def has_result?(exercise)

  end

  private

end
