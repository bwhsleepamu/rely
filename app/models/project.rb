class Project < ActiveRecord::Base
  ##
  # Associations
  has_many :project_managers
  has_many :project_scorers
  has_many :managers, :class_name => "User", :through => :project_managers, :source => :user
  has_many :scorers, :class_name => "User", :through => :project_scorers, :source => :user

  has_many :exercises, -> { where deleted: false }
  has_many :studies, -> { where deleted: false }
  has_many :study_types, -> { where deleted: false }
  has_many :groups, -> { where deleted: false }
  has_many :rules, -> { where deleted: false }

  belongs_to :owner, :class_name => "User", :foreign_key => :owner_id

  ##
  # Attributes
  # attr_accessible :description, :end_date, :name, :start_date, :manager_ids, :scorer_ids, :owner_id

  ##
  # Callbacks

  ##
  # Database Settings

  ##
  # Extensions
  include IndexMethods

  ##
  # Scopes
  scope :current, -> { where deleted: false }
  scope :with_owner, lambda { |user| where("owner_id = ?", user.id)  }
  scope :with_manager, lambda { |user| joins("left join project_managers on project_managers.project_id = projects.id").readonly(false).where("project_managers.user_id = ? or projects.owner_id = ?", user.id, user.id).uniq }
  scope :with_scorer, lambda { |user| joins(:project_scorers).readonly(false).where("project_scorers.user_id = ?", user.id).uniq }
  scope :search, lambda { |term| search_scope([:name, :description], term) }

  ##
  # Validations
  validates_presence_of :name, :owner_id

  ##
  # Class Methods

  ##
  # Instance Methods

  def destroy
    update_column :deleted, true
  end

  def to_s
    name
  end

  private

end
