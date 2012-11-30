class Result < ActiveRecord::Base
  ##
  # Associations
  has_one :reliability_id, :conditions => { :deleted => false }
  has_one :study_original_result
  has_one :assessment, :conditions => { :deleted => false }

  ##
  # Attributes
  attr_accessible :location, :result_type, :assessment_answers

  ##
  # Callbacks
  #after_save :exercise_completed?
  #before_save :set_result_type

  ##
  # Database Settings

  ##
  # Scopes
  scope :current, conditions: { deleted: false }
  scope :with_scorer, lambda { |user| joins(:reliability_id).readonly(false).where("reliability_ids.user_id = ?", user.id).uniq }

  ##
  # Validations
  validates_presence_of :location

  ##
  # Class Methods

  ##
  # Instance Methods
  def name
    "result_#{self.id}"
  end

  def study
    raise StandardError if reliability_id and study_original_result

    reliability_id ? reliability_id.study : (study_original_result ? study_original_result.study : nil)
  end

  def assessment_answers=(answer_hash)
    build_assessment(assessment_type: answer_hash.delete(:assessment_type))

    answer_hash.each do |question_id, answer|
      assessment.assessment_results.build(question_id: question_id, answer: answer)
    end
  end

  def destroy
    update_column :deleted, true
  end

  def rule
    raise StandardError if reliability_id and study_original_result

    reliability_id ? reliability_id.exercise.rule : (study_original_result ? study_original_result.rule : nil)
  end

  private

  def exercise_completed?
    if reliability_id and reliability_id.exercise.all_completed?
      reliability_id.exercise.completed_at = Time.zone.now()
      reliability_id.exercise.save
    end
  end

  def set_result_type
  end

end
