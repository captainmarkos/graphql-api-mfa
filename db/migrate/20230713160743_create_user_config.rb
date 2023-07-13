class CreateUserConfig < ActiveRecord::Migration[7.0]
  def change
    create_table :user_config do |t|
      t.references :user, null: false
      t.boolean :otp_enabled, null: false, default: false
      t.timestamps
    end
  end
end

