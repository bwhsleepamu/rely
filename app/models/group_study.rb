class GroupStudy < ActiveRecord::Base
  attr_accessible :group_id, :study_id
  belongs_to :group
  belongs_to :study
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id, :conditions => { :deleted => false }

end
