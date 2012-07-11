class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :title
      t.text :procedure
      t.boolean :deleted

      t.timestamps
    end
  end
end
