class Result < ActiveRecord::Base
  ##
  # Associations
  has_one :reliability_id, :conditions => { :deleted => false }
  has_one :study_original_result
  has_one :assessment, :conditions => { :deleted => false }
  has_many :assets

  ##
  # Attributes
  attr_accessible :location, :result_type, :assessment_answers, :asset_ids
  #accepts_nested_attributes_for :assets, :allow_destroy => true

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
  scope :with_studies, lambda { |studies| joins(:study_original_result).readonly(false).where("study_original_results.study_id in (?)", studies.pluck("studies.id")).uniq }
  scope :with_exercises, lambda { |exercises| joins(:reliability_id).readonly(false).where("reliability_ids.exercise_id in (?)", exercises.pluck("exercises.id")).uniq }

  ##
  # Validations
  validates_presence_of :location

  ##
  # Class Methods

  ##
  # Instance Methods
  def assign_attributes(*attrs)
    # Clean out asset ids that don't exist anymore (delete functionality fix)
    if attrs[0][:asset_ids]
      attrs[0][:asset_ids] = attrs[0][:asset_ids] & Asset.all.map{|asset| asset.id.to_s}
    end

    super(*attrs)
  end

  def name
    "result_#{self.id}"
  end

  def study
    raise StandardError if reliability_id and study_original_result

    reliability_id ? reliability_id.study : (study_original_result ? study_original_result.study : nil)
  end

  def viewable(user)
    # to be made
  end

  # TODO: THIS NEEDS FIXING FOR VALIDATION REASONS!
  def assessment_answers=(answer_hash)
    create_assessment(assessment_type: answer_hash.delete(:assessment_type))

    answer_hash.each do |question_id, answer|
      assessment.assessment_results.create(question_id: question_id, answer: answer)
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
