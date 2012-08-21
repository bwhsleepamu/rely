class Project < ActiveRecord::Base
  ##
  # Associations
  has_many :groups, :through => :project_groups, :conditions => { :deleted => false }
  has_many :project_groups

  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id

  ##
  # Attributes
  attr_accessible :description, :end_date, :name, :start_date, :group_ids

  ##
  # Callbacks

  ##
  # Database Settings

  ##
  # Scopes
  scope :current, conditions: { deleted: false }

  ##
  # Validations
  validates_presence_of :groups, :name

  ##
  # Class Methods

  ##
  # Instance Methods

  def destroy
    update_column :deleted, true
  end

  private

end
