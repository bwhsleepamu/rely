class Project < ActiveRecord::Base
  ##
  # Associations
  has_many :project_managers
  has_many :project_scorers
  has_many :managers, :class_name => "User", :through => :project_managers, :source => :user
  has_many :scorers, :class_name => "User", :through => :project_scorers, :source => :user

  has_many :exercises
  has_many :studies
  has_many :study_types
  has_many :groups
  has_many :rules


  belongs_to :owner, :class_name => "User", :foreign_key => :owner_id

  ##
  # Attributes
  attr_accessible :description, :end_date, :name, :start_date, :manager_ids, :scorer_ids, :owner_id

  ##
  # Callbacks

  ##
  # Database Settings

  ##
  # Scopes
  scope :current, conditions: { deleted: false }
  scope :with_owner, lambda { |user| where("owner_id = ?", user.id)  }
  scope :with_manager, lambda { |user| joins(:project_managers).where("project_managers.user_id = ?", user.id) }
  scope :with_scorer, lambda { |user| joins(:project_scorers).where("project_scorers.user_id = ?", user.id) }

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

  private

end
