class Rule < ActiveRecord::Base
  include Extensions::IndexMethods

  ##
  # Associations
  has_many :exercises, :conditions => { :deleted => false }
  belongs_to :project
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id


  ##
  # Attributes
  attr_accessible :procedure, :title, :assessment_type

  ##
  # Callbacks

  ##
  # Database Settings

  ##
  # Scopes
  scope :current, conditions: { deleted: false }
  scope :search, lambda { |*args| { conditions: [ 'LOWER(title) LIKE ? or LOWER(procedure) LIKE ?', '%' + args.first.downcase.split(' ').join('%') + '%', '%' + args.first.downcase.split(' ').join('%') + '%' ] } }

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
