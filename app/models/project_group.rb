class ProjectGroup < ActiveRecord::Base
  attr_accessible :group_id, :project_id
  belongs_to :group
  belongs_to :project
end
