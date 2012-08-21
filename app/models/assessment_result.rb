class AssessmentResult < ActiveRecord::Base
  ##
  # Associations
  belongs_to :assessment

  ##
  # Attributes
  attr_accessible :answer, :assessment_id, :question_id

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
    self.assessment_id
  end

  def destroy
    update_column :deleted, true
  end


  private

end
