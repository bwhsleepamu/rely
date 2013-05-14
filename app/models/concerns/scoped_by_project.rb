module ScopedByProject
  extend ActiveSupport::Concern

  included do
    # attr_accessible :updater_id, :project_id

    belongs_to :project

    validates_presence_of :updater_id, :project_id
    validate :project_must_be_manageable_by_creator

    scope :with_project, lambda { |project| where("project_id = ?", project.id) }
    scope :with_projects, lambda {|projects| where("project_id in (?)", projects.pluck("projects.id"))}
  end

  def project_must_be_manageable_by_creator
    c = User.find(updater_id)
    p = Project.find(project_id)

    unless c.all_projects.to_a.include? p
      errors.add(:project_id, "is from an invalid project")
    end
  end

end
