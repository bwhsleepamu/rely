class GroupStudy < ActiveRecord::Base
  attr_accessible :group_id, :study_id
  belongs_to :group
  belongs_to :study
end
