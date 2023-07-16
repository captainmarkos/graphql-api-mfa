class AddUniqueIndexToUsers < ActiveRecord::Migration[7.0]
  def up
    add_index :users, :email, unique: true

    remove_index :user_config, :user_id
    add_index :user_config, :user_id, unique: true
  end

  def down
    remove_index :users, :email

    remove_index :user_config, :user_id
    add_index :user_config, :user_id
  end
end
