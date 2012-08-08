class Exercise < ActiveRecord::Base
  ##
  # Associations
  belongs_to :admin, :class_name => "User", :foreign_key => :admin_id, :conditions => { :deleted => false, :system_admin => true }
  has_many :scorers, :class_name => "User", :through => :exercise_users, :source => :user
  has_many :exercise_users
  has_many :groups, :through => :exercise_groups
  has_many :exercise_groups
  belongs_to :rule, :conditions => { :deleted => false }

  ##
  # Attributes
  attr_accessible :admin_id, :assessment_type, :assigned_at, :completed_at, :deleted, :description, :name, :rule_id, :scorer_ids, :group_ids

  ##
  # Callbacks
  before_validation :set_assigned_at
  #after_create :send_assignment_emails
  after_save :assign_reliability_ids

  ##
  # Database Settings

  ##
  # Scopes
  scope :current, conditions: { deleted: false }

  ##
  # Validations
  validates_presence_of :assigned_at, :admin_id, :assessment_type, :name, :rule_id, :groups, :scorers
  validates_uniqueness_of :name

  ##
  # Class Methods

  ##
  # Instance Methods
  def all_studies
    groups.inject([]) {|all, group| all.concat(group.studies)}
  end

  def completed?(user)

    result = ActiveRecord::Base.connection.select_all("
      select count(*) from results r
      join studies s on r.study_id = s.id
      join group_studies gs on gs.study_id = s.id
      join groups g on gs.group_id = g.id
      join exercise_groups eg on eg.group_id = g.id
      join exercises e on eg.exercise_id = e.id
      where r.user_id = #{user.id}
      and e.id = #{self.id}
    ")

    MY_LOG.info result

    #
    # completed if results exists for user/exercise/study combo.
    groups.inject(true) do |previous_group_status, group|
      previous_group_status and group.studies.inject(true) {|previous_study_status, study| previous_study_status and (study.results.where({:user_id => user.id, :study_id => study.id}).count > 0)}
    end
  end

  def all_completed?
    all_completed = true

    scorers.each do |scorer|
      all_completed = false unless completed?(scorer)
    end

    all_completed
  end

  def send_assignment_emails
    scorers.each do |scorer|
      ExerciseMailer.notify_scorer(scorer, self).deliver
    end
  end

  private

  def set_assigned_at
    self[:assigned_at] ||= Time.zone.now()
  end

  def assign_reliability_ids
    scorers.each do |scorer|
      all_studies.each do |study|
        ReliabilityId.create(user_id: scorer.id, study_id: study.id, exercise_id: self.id) if ReliabilityId.where(user_id: scorer.id, study_id: study.id, exercise_id: self.id).empty?
      end
    end
  end
end
