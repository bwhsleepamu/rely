class Exercise < ActiveRecord::Base
  ##
  # Associations
  belongs_to :user, :foreign_key => :admin_id
  has_many :users, :through => :exercise_users
  has_many :exercise_users
  has_many :groups, :through => :exercise_groups
  has_many :exercise_groups
  belongs_to :rule

  ##
  # Attributes
  attr_accessible :admin_id, :assessment_id, :assigned_at, :completed_at, :deleted, :description, :name, :rule_id

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
