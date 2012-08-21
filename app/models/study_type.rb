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
  # Scopes
  scope :current, conditions: { deleted: false }

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
