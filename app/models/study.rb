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
  # Extensions
  include Extensions::IndexMethods
  include Extensions::ScopedByProject

  ##
  # Scopes
  scope :current, conditions: { deleted: false }
  scope :with_creator, lambda { |user| where("creator_id = ?", user.id)  }
  scope :with_project, lambda { |project| where("project_id = ?", project.id) }

  #scope :search, lambda { |*args| { conditions: [ 'LOWER(name) LIKE ? or LOWER(description) LIKE ?', '%' + args.first.downcase.split(' ').join('%') + '%', '%' + args.first.downcase.split(' ').join('%') + '%' ] } }

  ##
  # Validations
  validates_presence_of :study_type, :location, :original_id
  validates_uniqueness_of :original_id
  validate :study_type_belongs_to_same_project

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
    result_hash.each do |params|
      result_attrs = params.slice(:location, :assessment_answers)
      should_delete = params[:delete].to_i == 1 ? true : false

      next if params[:rule_id].blank? # Rule is needed in all cases

      MY_LOG.info "delete: #{should_delete} dasdf: #{result_attrs} "
      if should_delete
        MY_LOG.info "DELETE"
        # Destroy Original Result
        StudyOriginalResult.find(params[:study_original_result_id]).destroy unless params[:study_original_result_id].blank?
      elsif params[:study_original_result_id].blank?
        MY_LOG.info "CREATE"
        # Create New Original Result
        result = Result.new(result_attrs)
        study_original_result = StudyOriginalResult.new(rule_id: params[:rule_id])
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
    if study_type.project != project
      errors.add(:study_type, "has to belong to the same project as parent study.")
    end
  end

  private

end
