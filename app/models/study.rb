class Study < ActiveRecord::Base
  ##
  # Associations
  has_many :reliability_ids
  has_many :groups, :through => :group_studies, :conditions => { :deleted => false }
  has_many :group_studies
  has_many :study_original_results
  has_many :original_results, :class_name => "Result", :through => :study_original_results, :conditions => { :deleted => false}, :source => :result

  belongs_to :study_type


  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id


  ##
  # Attributes
  attr_accessible :location, :original_id, :study_type_id, :results
  attr_accessor :results

  ##
  # Callbacks

  ##
  # Database Settings

  ##
  # Scopes
  scope :current, conditions: { deleted: false }

  ##
  # Validations
  validates_presence_of :study_type, :location, :original_id
  validates_uniqueness_of :original_id

  ##
  # Class Methods

  ##
  # Instance Methods
  def name
    original_id
  end

  #def group(reliability_id)
  #  reliability_id.exercise.groups.joins(:studies).where(:studies => { :id => id} ).first
  #end

  def long_name
    "#{original_id} #{location}"
  end

  def to_s
    "id: #{original_id} location: #{location}"
  end

  def destroy
    update_column :deleted, true
  end

  def results=(result_hash)
    # rule_id MUST exist
    # study_id exists or does not exist ==>
      # sor_id exists or does not exist
    result_hash.each do |params|
      MY_LOG.info "before: #{study_original_results.length} #{study_original_results.count}"
      result_attrs = params.slice(:location, :assessment_answers)

      if params[:rule_id]
        if params[:study_id]
          MY_LOG.info "STUDY"
          if params[:study_original_result_id]
            MY_LOG.info "SOR"
            # delete if delete flag?
            sor = StudyOriginalResult.find(params[:study_original_result_id])
            sor.result.update_attributes(result_attrs)
          else
            result = Result.new(result_attrs)
            sor = StudyOriginalResult.new(rule_id: params[:rule_id], study_id: params[:study_id])
            sor.result = result
            study_original_results << sor
          end
        else
          result = Result.new(params.slice(:location, :assessment_answers))
          sor = StudyOriginalResult.new(rule_id: params[:rule_id])
          sor.result = result
          sor.study = self
          study_original_results << sor
        end
      end
      MY_LOG.info "after: #{study_original_results.length} #{study_original_results.count}"
    end
  end

  private

end
