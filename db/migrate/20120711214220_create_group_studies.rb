class CreateGroupStudies < ActiveRecord::Migration
  def change
    create_table :group_studies do |t|
      t.integer :group_id
      t.integer :study_id

      t.timestamps
    end
  end
end
