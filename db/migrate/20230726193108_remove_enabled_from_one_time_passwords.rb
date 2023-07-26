class RemoveEnabledFromOneTimePasswords < ActiveRecord::Migration[7.0]
  def up
    remove_column :one_time_passwords, :enabled  
  end

  def down
    add_column :one_time_passwords, :enabled, :boolean, null: false, default: false
  end
end
