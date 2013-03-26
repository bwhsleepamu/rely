class GroupStudy < ActiveRecord::Base
  # attr_accessible :group_id, :study_id
  belongs_to :group
  belongs_to :study
  belongs_to :creator, -> { where deleted: false }, :class_name => "User", :foreign_key => :creator_id

end
