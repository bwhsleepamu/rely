class Rule < ActiveRecord::Base
  ##
  # Associations
  has_many :exercises
  has_many :results
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id, :conditions => { :deleted => false }


  ##
  # Attributes
  attr_accessible :deleted, :procedure, :title

  ##
  # Callbacks

  ##
  # Database Settings

  ##
  # Scopes
  scope :current, conditions: { }

  ##
  # Validations

  ##
  # Class Methods

  ##
  # Instance Methods
  def name
    self.title
  end

  private

end
