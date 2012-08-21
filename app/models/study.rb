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
  def self.find_by_reliability_id(reliability_id)
    ReliabilityId.find_by_unique_id(reliability_id).study
  end

  ##
  # Instance Methods
  def name
    original_id
  end

  def long_name
    "#{original_id} #{location}"
  end

  def to_s
    "id: #{original_id} location: #{location}"
  end

  def has_result?(user, exercise)
    reliability_ids.where(:exercise_id => exercise.id, :user_id => user.id).first.result
  end

  def result(user, exercise)
    reliability_ids.where(:exercise_id => exercise.id, :user_id => user.id).first.result
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

  def destroy
    update_column :deleted, true
  end

  private

end
