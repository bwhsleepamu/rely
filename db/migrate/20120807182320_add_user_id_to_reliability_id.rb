class AddUserIdToReliabilityId < ActiveRecord::Migration
  def change
    add_column :reliability_ids, :user_id, :integer
  end
end
