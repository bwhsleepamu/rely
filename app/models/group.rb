class Group < ActiveRecord::Base
  ##
  # Associations
  has_many :studies, :through => :group_studies, :conditions => { :deleted => false }
  has_many :group_studies
  has_many :exercises, :through => :exercise_groups, :conditions => { :deleted => false }
  has_many :exercise_groups

  belongs_to :group
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id
  ##
  # Attributes
  attr_accessible :description, :name, :study_ids

  ##
  # Callbacks

  ##
  # Database Settings

  ##
  # Extensions
  include Extensions::IndexMethods
  include Extensions::ScopedByProject

  ##
  # Scopes
  scope :current, conditions: { deleted: false }
  scope :with_creator, lambda { |user| where("creator_id = ?", user.id)  }
  scope :search, lambda { |term| search_scope([:name, :description], term) }

  ##
  # Validations
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :project_id
  validate :studies_belong_to_same_project

  ##
  # Class Methods

  ##
  # Instance Methods

  def destroy
    update_column :deleted, true
  end

  # Custom Validations
  def studies_belong_to_same_project
    studies.each do |s|
      if s.project != project
        errors.add(:studies, "have to all belong to the same project as parent group.")
        break
      end
    end
  end

  private

end
