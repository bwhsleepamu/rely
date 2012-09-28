class RefactorResultsReliabilityId < ActiveRecord::Migration
  def up
    remove_column :results, :reliability_id_id
    add_column :reliability_ids, :result_id, :integer
  end

  def down
    add_column :results, :reliability_id_id, :integer
    remove_column :reliability_ids, :result_id
  end
end
