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
  def self.find_by_reliability_id(reliability_id)
    ReliabilityId.find_by_unique_id(reliability_id).study
  end
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

  def has_result?(user, exercise)
    results.where(:exercise_id => exercise.id, :user_id => user.id).count > 0
  end

  def result(user, exercise)
    results.where(:exercise_id => exercise.id, :user_id => user.id).first if has_result?(user, exercise)
  end

  def reliability_id(user, exercise)
    r_ids = reliability_ids.where(:user_id => user.id, :exercise_id => exercise.id)
    if r_ids
      r_ids.first
    else
      nil
    end
  end

  def reliability_unique_id(user, exercise)
    r_id = reliability_id(user, exercise)
    r_id ? r_id.unique_id : nil
  end


  private

end
