class CreateStudies < ActiveRecord::Migration
  def change
    create_table :studies do |t|
      t.string :original_id
      t.integer :study_type_id
      t.string :location
      t.boolean :deleted

      t.timestamps
    end
  end
end
