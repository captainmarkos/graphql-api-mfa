class UserConfig < ApplicationRecord
  self.table_name = 'user_config'

  belongs_to :user
end
