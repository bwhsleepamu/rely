class Exercise < ActiveRecord::Base
  ##
  # Associations
  belongs_to :admin, :class_name => "User", :foreign_key => :admin_id, :conditions => { :deleted => false }
  has_many :users, :through => :exercise_users
  has_many :exercise_users
  has_many :groups, :through => :exercise_groups
  has_many :exercise_groups
  belongs_to :rule, :conditions => { :deleted => false }

  ##
  # Attributes
  attr_accessible :admin_id, :assessment_type, :assigned_at, :completed_at, :deleted, :description, :name, :rule_id

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
