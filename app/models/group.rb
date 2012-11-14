class Group < ActiveRecord::Base
  ##
  # Associations
  has_many :studies, :through => :group_studies, :conditions => { :deleted => false }
  has_many :group_studies
  has_many :exercises, :through => :exercise_groups, :conditions => { :deleted => false }
  has_many :exercise_groups

  belongs_to :group
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id
  belongs_to :project
  ##
  # Attributes
  attr_accessible :description, :name, :study_ids

  ##
  # Callbacks

  ##
  # Database Settings

  ##
  # Scopes
  scope :current, conditions: { deleted: false }
  scope :with_creator, lambda { |user| where("creator_id = ?", user.id)  }
  scope :with_project, lambda { |project| where("project_id = ?", project.id) }

  ##
  # Validations
  validates_presence_of :name

  ##
  # Class Methods

  ##
  # Instance Methods

  def destroy
    update_column :deleted, true
  end

  private

end
