class Project < ActiveRecord::Base
  ##
  # Associations
  has_many :project_managers
  has_many :project_scorers
  has_many :managers, :class_name => "User", :through => :project_managers, :source => :user
  has_many :scorers, :class_name => "User", :through => :project_scorers, :source => :user

  has_many :exercises, :conditions => { :deleted => false }
  has_many :studies, :conditions => { :deleted => false }
  has_many :study_types, :conditions => { :deleted => false }
  has_many :groups, :conditions => { :deleted => false }
  has_many :rules, :conditions => { :deleted => false }


  belongs_to :owner, :class_name => "User", :foreign_key => :owner_id

  ##
  # Attributes
  attr_accessible :description, :end_date, :name, :start_date, :manager_ids, :scorer_ids, :owner_id

  ##
  # Callbacks

  ##
  # Database Settings

  ##
  # Extensions
  include Extensions::IndexMethods

  ##
  # Scopes
  scope :current, conditions: { deleted: false }
  scope :with_owner, lambda { |user| where("owner_id = ?", user.id)  }
  scope :with_manager, lambda { |user| joins("left join project_managers on project_managers.project_id = projects.id").readonly(false).where("project_managers.user_id = ? or projects.owner_id = ?", user.id, user.id).uniq }
  scope :with_scorer, lambda { |user| joins(:project_scorers).readonly(false).where("project_scorers.user_id = ?", user.id).uniq }
  #scope :with_owner_or_manager, lambda { |user| joins(:project_managers).where("project_managers.user_id = ? or projects.owner_id = ?", user.id, user.id)}

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
