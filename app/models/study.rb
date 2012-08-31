class Study < ActiveRecord::Base
  ##
  # Associations
  has_many :reliability_ids
  has_many :groups, :through => :group_studies, :conditions => { :deleted => false }
  has_many :group_studies
  belongs_to :study_type

  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id

  ##
  # Attributes
  attr_accessible :location, :original_id, :study_type_id

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
    original_id
  end

  def group(reliability_id)
    reliability_id.exercise.groups.joins(:studies).where(:studies => { :id => id} ).first
  end

  def long_name
    "#{original_id} #{location}"
  end

  def to_s
    "id: #{original_id} location: #{location}"
  end

  def destroy
    update_column :deleted, true
  end

  private

end
