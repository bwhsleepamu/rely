class Asset < ActiveRecord::Base
  # attr_accessible :result_id, :asset

  include Rails.application.routes.url_helpers

  belongs_to :result
  has_attached_file :asset

  validates :asset, :attachment_presence => true

  def to_jq_upload
    {
        "name" => read_attribute(:asset_file_name),
        "size" => read_attribute(:asset_file_size),
        "asset_id" => read_attribute(:id),
        "url" => download_result_asset_path(self),
        "delete_url" => result_asset_path(self),
        "delete_type" => "DELETE"
    }
  end

  scope :current, -> {}
  scope :with_results, lambda {|results| where("result_id in (?)", results.pluck("results.id"))}
  scope :unattached, -> { where result_id: nil }

  def self.download_exercise(exercise_id, current_user, temp_path)
    exercise = current_user.all_exercises.find_by_id(exercise_id)
    
    if exercise
      Zip::File.open(temp_path, true) do |zipfile|
        exercise.all_studies.each do |study|
          original_result = study.study_original_results.find_by_rule_id(exercise.rule.id)

          if original_result and original_result.result
            # Original Result
            original_result.result.assets.each do |asset|
              zipfile.add(File.join("original_results", study.original_id, asset.asset_file_name), asset.asset.path)
            end
          end

          exercise.reliability_ids.where(study_id: study.id).each do |rid|
            if rid.result
              rid.result.assets.each do |asset|
                zipfile.add(File.join(rid.user.name, study.original_id, asset.asset_file_name), asset.asset.path)
              end
            end
          end
        end

        "exercise_#{exercise.name}"
      end
    end
  end


  def self.download_result(result_id, current_user, temp_path)
    result = current_user.all_viewable_results.find_by_id(result_id)
    if result
      Zip::File.open(temp_path, true) do |zipfile|
        result.assets.each do |asset|
          zipfile.add(File.join(asset.asset_file_name), asset.asset.path)
        end
      end
      "result_#{result.id}"
    end
  end

end
