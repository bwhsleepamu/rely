class Exercise < ActiveRecord::Base
  include Extensions::IndexMethods

  ##
  # Associations
  belongs_to :owner, :class_name => "User", :foreign_key => :owner_id
  has_many :scorers, :class_name => "User", :through => :exercise_scorers, :source => :user, :conditions => { :deleted => false }
  has_many :exercise_scorers
  has_many :groups, :through => :exercise_groups, :conditions => { :deleted => false }
  has_many :exercise_groups
  has_many :reliability_ids, :conditions => { :deleted => false }
  belongs_to :project
  belongs_to :rule

  ##
  # Attributes
  attr_accessible :owner_id, :assigned_at, :completed_at, :description, :name, :rule_id, :scorer_ids, :group_ids

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
  scope :with_owner, lambda { |user| where("owner_id = ?", user.id)  }
  scope :with_manager, lambda { |user| where("project_id in ( select project_id from projects p join project_managers pm on p.id = pm.project_id where pm.user_id = ?)", user.id) }
  scope :with_scorer, lambda { |user| joins(:exercise_scorers).where("exercise_scorers.user_id = ?", user.id) }
  scope :with_project, lambda { |project| where("project_id = ?", project.id) }
  scope :search, lambda { |*args| { conditions: [ 'LOWER(name) LIKE ? or LOWER(description) LIKE ?', '%' + args.first.downcase.split(' ').join('%') + '%', '%' + args.first.downcase.split(' ').join('%') + '%' ] } }

  ##
  # Validations
  validates_presence_of :assigned_at, :owner_id, :name, :rule_id, :groups, :scorers
  validates_uniqueness_of :name

  ##
  # Class Methods


  ##
  # Instance Methods
  # TODO: Refactor method names to maintain consistency

  def all_studies
    groups.inject([]) {|all, group| all.concat(group.studies)}
  end

  def all_results
    Result.joins(:reliability_id).where(:reliability_ids => {:exercise_id => id})
  end

  def count_completed_results(scorer)
    ## TODO: combine with completed?

    count = 0

    reliability_ids.where(:user_id => scorer.id).each do |rid|
      count += 1 if rid.result
    end

    count
  end

  def completed?(scorer)
    completed = true


    ## TODO: Might be faster to use a well-made select instead of a loop
    reliability_ids.where(:user_id => scorer.id).each do |rid|
      completed = false if rid.result.nil?
    end

    #all_studies.each do |study|
    #  rid = study.reliability_id(scorer, self)
    #  completed = false if rid.result.nil?
    #end

    ## TODO: finalize select attempts
    #result = ActiveRecord::Base.connection.select_all("
    #  select count(*) from reliability_ids rids
    #  join results r on r.reliability_id_id = rids.id
    #  where user_id = #{scorer.id}
    #  and exercise_id = #{id}
    #  and
    #")
    #
    #result = ActiveRecord::Base.connection.select_all("
    #  select count(*) from results r
    #  join reliability_ids rids on rids.id = r.reliability_id_id
    #  join exercises e on e.id = rids.exercise_id
    #  where rids.user_id = #{user.id}
    #  and e.id = #{self.id}
    #")

    #
    # completed if result exists for user/exercise/study combo.
    #groups.inject(true) do |previous_group_status, group|
    #  previous_group_status and group.studies.inject(true) {|previous_study_status, study| previous_study_status and (study.results.where({:user_id => user.id, :study_id => study.id}).count > 0)}
    #end

    completed
  end

  def count_completed
    count = 0

    scorers.each do |scorer|
      count += 1 if completed? scorer
    end

    count
  end

  def all_completed?
    #all_completed = true
    #
    #scorers.each do |scorer|
    #  all_completed = false unless completed?(scorer)
    #end
    #
    #all_completed
    count_completed == scorers.count
  end

  def percent_completed
    (all_results.length.to_f / reliability_ids.length.to_f) * 100.0
  end

  def send_assignment_emails
    scorers.each do |scorer|
      ExerciseMailer.notify_scorer(scorer, self).deliver
    end
  end

  def pending_scorers
    scorers.select {|scorer| !completed?(scorer) }
  end

  def finished_scorers
    scorers.select {|scorer| completed?(scorer) }
  end

  def destroy
    update_column :deleted, true
  end

  def check_completion
    if all_completed?
      update_column :completed_at, Time.zone.now()
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
