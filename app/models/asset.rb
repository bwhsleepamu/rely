class Asset < ActiveRecord::Base
  attr_accessible :result_id, :asset

  include Rails.application.routes.url_helpers

  belongs_to :result
  has_attached_file :asset

  validates :asset, :attachment_presence => true

  def to_jq_upload
    {
        "name" => read_attribute(:asset_file_name),
        "size" => read_attribute(:asset_file_size),
        "asset_id" => read_attribute(:id),
        "url" => asset.url(:original),
        "delete_url" => asset_path(self),
        "delete_type" => "DELETE"
    }
  end


end
