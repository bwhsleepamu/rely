json.array!(@assets) do |asset|
  json.url download_result_asset_path(asset)
  json.delete_url result_asset_path(asset)
  json.delete_type "DELETE"
  json.asset_id asset.id
  json.size asset.asset_file_size
  json.name asset.asset_file_name
end
