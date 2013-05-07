class Study < ActiveRecord::Base
  ##
  # Associations
  has_many :reliability_ids
  has_many :groups, -> { where deleted: false }, :through => :group_studies
  has_many :group_studies
  has_many :study_original_results
  has_many :original_results, -> { where deleted: false }, :class_name => "Result", :through => :study_original_results, :source => :result

  belongs_to :study_type
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id


  ##
  # Attributes
  # attr_accessible :location, :original_id, :study_type_id, :results
  attr_accessor :results

  ##
  # Callbacks

  ##
  # Database Settings

  ##
  # Extensions
  include Extensions::IndexMethods
  include Extensions::ScopedByProject

  ##
  # Scopes
  scope :current, -> { where deleted: false }
  scope :with_creator, lambda { |user| where("creator_id = ?", user.id)  }
  scope :with_project, lambda { |project| where("project_id = ?", project.id) }
  scope :search, lambda { |term| search_scope([:original_id, :location, {join: :project, column: :name}], term) }

  ##
  # Validations
  validates_presence_of :study_type, :location, :original_id
  validates_uniqueness_of :original_id, :scope => :project_id
  validate :study_type_belongs_to_same_project
  validates_associated :study_original_results

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
    MY_LOG.info result_hash
    #raise StandardError
    result_hash.each do |params|
      MY_LOG.info "params: #{params}"

      should_delete = params.delete(:delete).to_i == 1 ? true : false
      rule_id = params.delete(:rule_id)
      result_attrs = params

      MY_LOG.info "result_attrs: #{result_attrs}"

      next if rule_id.blank? # Rule is needed in all cases

      #MY_LOG.info "delete: #{should_delete} dasdf: #{result_attrs} "
      if should_delete
        #MY_LOG.info "DELETE"
        # Destroy Original Result
        StudyOriginalResult.find(params[:study_original_result_id]).destroy unless params[:study_original_result_id].blank?
      elsif params[:study_original_result_id].blank?

        MY_LOG.info "CREATE"
        # Create New Original Result
        study_original_result = StudyOriginalResult.new(rule_id: rule_id)
        result = Result.new
        result.study_original_result = study_original_result
        result.update_attributes(result_attrs)
        study_original_result.result = result
        study_original_result.study = self

        study_original_results << study_original_result

      else
        MY_LOG.info "UPDATE"
        # Update Existing Original Result
        study_original_result = StudyOriginalResult.find(params[:study_original_result_id])
        study_original_result.result.update_attributes(result_attrs)
      end


    end
  end

  def original_result(rule)
    sor = StudyOriginalResult.find_by_study_id_and_rule_id(self.id, rule.id)
    sor ? sor.result : nil
  end

  # Custom Validation
  def study_type_belongs_to_same_project
    if !study_type or study_type.project != project
      errors.add(:study_type, "has to belong to the same project as parent study.")
    end
  end

  private

end
