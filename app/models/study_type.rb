class StudyType < ActiveRecord::Base
  ##
  # Associations
  has_many :studies, :conditions => { :deleted => false }
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id


  ##
  # Attributes
  attr_accessible :description, :name

  ##
  # Callbacks

  ##
  # Database Settings

  ##
  # Extentions
  include Extensions::IndexMethods
  include Extensions::ScopedByProject

  ##
  # Scopes
  scope :current, conditions: { deleted: false }
  scope :with_creator, lambda { |user| where("creator_id = ?", user.id)  }
  scope :with_project, lambda { |project| where("project_id = ?", project.id) }
  scope :search, lambda {|term| search_scope([:name, :description], term)}

  ##
  # Validations
  validates_presence_of :name
  validates_uniqueness_of :name

  ##
  # Class Methods

  ##
  # Instance Methods
  def destroy
    update_column :deleted, true
  end

  private

end
