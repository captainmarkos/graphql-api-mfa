class UserConfig < ActiveRecord::Base
  self.table_name = 'user_config'

  belongs_to :user
end
