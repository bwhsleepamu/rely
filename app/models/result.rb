class Result < ActiveRecord::Base
  ##
  # Associations
  has_one :reliability_id, -> { where deleted: false }
  has_one :study_original_result
  has_one :assessment, -> { where deleted: false }, :autosave => true
  has_many :assets

  ##
  # Attributes
  # attr_accessible :location, :result_type, :assessment_answers, :asset_ids
  #accepts_nested_attributes_for :assets, :allow_destroy => true

  ##
  # Callbacks
  #after_save :exercise_completed?
  #before_save :set_result_type

  ##
  # Database Settings

  ##
  # Scopes
  scope :current, -> { where deleted: false }
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
    #raise StandardError
    # Clean out asset ids that don't exist anymore (delete functionality fix)
    if attrs[0][:asset_ids]
      attrs[0][:asset_ids] = attrs[0][:asset_ids] & Asset.all.map{|asset| asset.id.to_s}
    end

    # Set Associations - they will be needed in assigning attributes
    r_id = attrs[0].delete(:reliability_id)
    sor_id = attrs[0].delete(:study_original_result_id)
    self.reliability_id = ReliabilityId.find_by_id(r_id) unless self.reliability_id
    self.study_original_result = StudyOriginalResult.find_by_id(sor_id) unless self.study_original_result

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
    build_assessment(assessment_type: rule.assessment_type) unless assessment.present?

    answer_hash.each do |question_id, answer|
      if assessment.new_record?
        assessment.assessment_results.build(question_id: question_id, answer: answer)
      else
        #MY_LOG.error assessment.assessment_results
        #MY_LOG.error question_id

        assessment.assessment_results.select{|ar| ar.question_id.to_i == question_id.to_i}.first.answer = answer
      end
    end

  end

  def destroy
    update_column :deleted, true
  end

  def rule
    raise StandardError if reliability_id and study_original_result
    raise StandardError unless reliability_id or study_original_result

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
