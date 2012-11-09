class Project < ActiveRecord::Base
  ##
  # Associations
  has_many :managers, :class_name => "User", :through => :project_managers, :source => :user
  has_many :project_managers
  has_many :scorers, :class_name => "User", :through => :project_scorers, :source => :user
  has_many :project_scorers

  belongs_to :owner, :class_name => "User", :foreign_key => :owner_id

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
