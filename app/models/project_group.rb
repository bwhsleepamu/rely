class ProjectGroup < ActiveRecord::Base
  attr_accessible :group_id, :project_id
  has_many :groups
  has_many :projects
end
