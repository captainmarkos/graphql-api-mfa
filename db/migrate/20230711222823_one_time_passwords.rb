class OneTimePasswords < ActiveRecord::Migration[7.0]
  def change
    create_table :one_time_passwords do |t|
      t.references :user, null: false
      t.text :otp_secret, null: false, index: { unique: true }
      t.boolean :enabled, null: false, default: false
      t.timestamps
    end
  end
end
