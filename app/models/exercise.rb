class Exercise < ActiveRecord::Base
  ##
  # Associations
  belongs_to :admin, :class_name => "User", :foreign_key => :admin_id, :conditions => { :deleted => false, :system_admin => true }
  has_many :scorers, :class_name => "User", :through => :exercise_users
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
  def completed?(user)
    # completed if results exists for user/exercise/study combo.
    completed = true

    studies.each do |study|
      completed = false unless results.where({:user_id => user.id, :study_id => study.id})
    end

    completed
  end

  def all_completed?
    all_completed = true

    users.each do |user|
      all_completed = false unless completed?(user)
    end

    all_completed
  end

  private

  def send_assignment_emails
    users.first do |user|
      ExerciseMailer.notify_scorer(user, self).deliver
    end
  end

end
