class User < ActiveRecord::Base
  ##
  # Associations

  #User
  has_many :authentications

  # Owner
  has_many :owned_exercises, :class_name => "Exercise", :foreign_key => :owner_id, :conditions => { :deleted => false }
  has_many :owned_projects, :class_name => "Project", :foreign_key => :owner_id, :conditions => { :deleted => false }

  #Creator
  has_many :groups, :foreign_key => :creator_id, :conditions => { :deleted => false }
  has_many :group_studies, :foreign_key => :creator_id
  has_many :studies, :foreign_key => :creator_id, :conditions => { :deleted => false }
  has_many :study_types, :foreign_key => :creator_id, :conditions => { :deleted => false }
  has_many :rules, :foreign_key => :creator_id, :conditions => { :deleted => false }

  # Manager
  has_many :managed_projects, :class_name => "Project", :through => :project_managers, :source => :project
  has_many :project_managers

  # Scorer
  has_many :assigned_exercises, :class_name => "Exercise", :through => :exercise_scorers, :source => :exercise, :conditions => { :deleted => false }
  has_many :exercise_scorers
  has_many :reliability_ids, :conditions => { :deleted => false }
  has_many :assigned_projects, :class_name => "Project", :through => :project_managers, :source => :project, :conditions => { :deleted => false }
  has_many :project_scorers

  ##
  # Attributes

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :first_name, :last_name


  ##
  # Callbacks
  after_create :notify_system_admins
  before_update :status_activated

  ##
  # Constants
  STATUS = ["active", "denied", "inactive", "pending"].collect{|i| [i,i]}

  ##
  # Database Settings

  ##
  # Devise

  # Include default devise modules.
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  ##
  # Scopes
  scope :current, conditions: { deleted: false }
  scope :search, lambda { |*args| { conditions: [ 'LOWER(first_name) LIKE ? or LOWER(last_name) LIKE ? or LOWER(email) LIKE ?', '%' + args.first.downcase.split(' ').join('%') + '%', '%' + args.first.downcase.split(' ').join('%') + '%', '%' + args.first.downcase.split(' ').join('%') + '%' ] } }
  scope :status, lambda { |*args|  { conditions: ["users.status IN (?)", args.first] } }
  scope :system_admins, conditions: { system_admin: true }
  #scope :scorers, conditions: { system_admin: false }


  ##
  # Validations
  validates_presence_of :first_name, :last_name

  ##
  # Class Methods

  ##
  # Instance Methods
  def apply_omniauth(omniauth)
    unless omniauth['info'].blank?
      self.email = omniauth['info']['email'] if email.blank?
      self.first_name = omniauth['info']['first_name'] if first_name.blank?
      self.last_name = omniauth['info']['last_name'] if last_name.blank?
    end
    authentications.build( provider: omniauth['provider'], uid: omniauth['uid'] )
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def avatar_url(size = 80, default = 'mm')
    gravatar_id = Digest::MD5.hexdigest(self.email.downcase)
    "//gravatar.com/avatar/#{gravatar_id}.png?&s=#{size}&r=pg&d=#{default}"
  end

  #def viewable_exercises
  #    assigned_exercises.scoped.current
  #  end
  #end

  # Overriding Devise built-in active_for_authentication? method
  def active_for_authentication?
    super and self.status == 'active' and not self.deleted?
  end

  def name
    "#{first_name} #{last_name}"
  end

  def reverse_name
    "#{last_name}, #{first_name}"
  end

  def destroy
    update_attribute :deleted, true
    update_attribute :status, 'inactive'
  end

  def exercise_reliability_ids(exercise)
    reliability_ids.where(:exercise_id => exercise.id)
  end

  # Accessible Associations
  def all_projects
    Project.current.with_manager(self)
  end

  def all_rules
    Rule.current.with_projects(all_projects)
  end

  def all_exercise_rules
    Rule.current.with_exercises(assigned_exercises.scoped)
  end

  def all_viewable_rules
    ids = [all_rules, all_exercise_rules].map do |rel|
      rel.pluck("rules.id")
    end.flatten

    Rule.current.where("id in (?)", ids)
  end

  def all_exercises
    Exercise.current.with_projects(all_projects)
  end

  def all_groups
    Group.current.with_projects(all_projects)
  end

  def all_studies
    Study.current.with_projects(all_projects)
  end

  def all_study_types
    StudyType.current.with_projects(all_projects)
  end

  def all_reliability_ids
    ReliabilityId.current.with_user(self)
  end

  def all_results
    Result.current.with_scorer(self)
  end

  def all_original_results
    Result.current.with_studies(all_studies)
  end

  def all_exercise_results
    Result.current.with_exercises(all_exercises)
  end

  def all_viewable_results
    ids = [all_results, all_original_results, all_exercise_results].map do |rel|
      rel.pluck("results.id")
    end.flatten

    Result.current.where("id in (?)", ids)
  end

  def all_assets
    Asset.current.with_results(all_viewable_results)
  end

  private

  def notify_system_admins
    User.current.system_admins.each do |system_admin|
      UserMailer.notify_system_admin(system_admin, self).deliver if Rails.env.production?
    end
  end

  def status_activated
    unless self.new_record? or self.changes.blank?
      if self.changes['status'] and self.changes['status'][1] == 'active'
        UserMailer.status_activated(self).deliver if Rails.env.production?
      end
    end
  end


end
