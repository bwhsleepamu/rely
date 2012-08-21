class Rule < ActiveRecord::Base
  ##
  # Associations
  has_many :exercises, :conditions => { :deleted => false }
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id


  ##
  # Attributes
  attr_accessible :procedure, :title

  ##
  # Callbacks

  ##
  # Database Settings

  ##
  # Scopes
  scope :current, conditions: { deleted: false }

  ##
  # Validations

  ##
  # Class Methods

  ##
  # Instance Methods
  def name
    self.title
  end

  def destroy
    update_column :deleted, true
  end

  private

end
