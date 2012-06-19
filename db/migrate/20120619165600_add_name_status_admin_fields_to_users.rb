class AddNameStatusAdminFieldsToUsers < ActiveRecord::Migration
  def up
    change_table(:users) do |t|
      t.string :first_name
      t.string :last_name
      t.string :status, null: false, default: "pending"
      t.boolean :deleted, null: false, default: false
      t.boolean :system_admin, null: false, default: false

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      # Lockable
      t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      # Token authenticatable
      t.string :authentication_token

    end

    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :unlock_token,         :unique => true
    add_index :users, :authentication_token, :unique => true
  end

  def down
    change_table(:users) do |t|
      t.remove :first_name, :last_name, :status, :system_admin, :confirmation_token, :confirmed_at,
               :confirmation_sent_at, :unconfirmed_email, :failed_attempts, :unlock_token, :locked_at, :authentication_token, :deleted
    end
  end
end
