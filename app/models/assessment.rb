class Assessment < ActiveRecord::Base
  ##
  # Associations
  belongs_to :result
  has_many :assessment_results

  ##
  # Attributes
  attr_accessible :assessment_type, :deleted, :result_id

  ##
  # Callbacks

  ##
  # Constants
  TYPES = [
      { :title => "type1" },
      { :title => "type2" },
      { :title => "type3" }
  ]

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
    self.assessment_type
  end

  private

end
