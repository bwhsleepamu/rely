class CreateStudyTypes < ActiveRecord::Migration
  def change
    create_table :study_types do |t|
      t.string :name
      t.text :description
      t.boolean :deleted

      t.timestamps
    end
  end
end
