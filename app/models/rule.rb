class Rule < ActiveRecord::Base
  ##
  # Associations
  has_many :exercises, :conditions => { :deleted => false }
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id

  ##
  # Attributes
  attr_accessible :procedure, :title, :assessment_type

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
  #scope :search, lambda { |*args| { conditions: [ 'LOWER(title) LIKE ? or LOWER(procedure) LIKE ? or LOWER(assessment_type) LIKE ?', '%' + args.first.downcase.split(' ').join('%') + '%', '%' + args.first.downcase.split(' ').join('%') + '%', '%' + args.first.downcase.split(' ').join('%') + '%' ] } }
  scope :search, lambda { |term| search_scope([:title, :procedure, :assessment_type], term) }
  scope :with_exercises, lambda {|exercises| joins(:exercises).readonly(false).where("exercises.id in (?)", exercises.pluck("exercises.id")).uniq}

  ##
  # Validations
  validates_presence_of :project_id, :title, :procedure
  validates_uniqueness_of :title, :scope => :project_id
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
