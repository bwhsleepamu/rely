class GroupStudy < ActiveRecord::Base
  attr_accessible :group_id, :study_id
  has_many :groups
  has_many :studies
end
