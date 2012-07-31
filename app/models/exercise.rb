class Exercise < ActiveRecord::Base
  ##
  # Associations
  belongs_to :admin, :class_name => "User", :foreign_key => :admin_id, :conditions => { :deleted => false, :system_admin => true }
  has_many :users, :through => :exercise_users
  has_many :exercise_users
  has_many :groups, :through => :exercise_groups
  has_many :exercise_groups
  belongs_to :rule, :conditions => { :deleted => false }

  ##
  # Attributes
  attr_accessible :admin_id, :assessment_type, :assigned_at, :completed_at, :deleted, :description, :name, :rule_id, :user_ids, :group_ids

  ##
  # Callbacks
  after_create :send_assignment_emails

  ##
  # Database Settings

  ##
  # Scopes
  scope :current, conditions: { deleted: false }

  ##
  # Validations
  validates_presence_of :assigned_at, :admin_id, :assessment_type, :name, :rule_id, :groups, :users

  ##
  # Class Methods

  ##
  # Instance Methods

  private

  def send_assignment_emails
    users.first do |user|
      ExerciseMailer.notify_scorer(user, self).deliver
    end
  end

end
