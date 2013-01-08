class Asset < ActiveRecord::Base
  attr_accessible :asset_content_type, :asset_file_name, :asset_file_size, :asset_updated_at, :result_id

  belongs_to :result
  has_attached_file :asset

  validates :asset, :attachment_presence => true
end
