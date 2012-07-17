class ProjectGroup < ActiveRecord::Base
  attr_accessible :group_id, :project_id
  belongs_to :group
  belongs_to :project
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id, :conditions => { :deleted => false }

end
