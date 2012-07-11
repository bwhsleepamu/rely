class CreateReliabilityIds < ActiveRecord::Migration
  def change
    create_table :reliability_ids do |t|
      t.string :unique_id
      t.integer :study_id
      t.boolean :deleted

      t.timestamps
    end
  end
end
