class UserConfig < ActiveRecord::Base
  self.table_name = 'user_config'

  belongs_to :user

  after_commit :enable_otp, if: :otp_enabled?
  after_commit :disable_all_otps, unless: :otp_enabled?

  private

  def enable_otp
    if (otp = user.one_time_passwords.recent).present?
      otp.update!(enabled: true)
    else
      OneTimePassword.create!(user_id: user_id, enabled: true)
    end
  end

  def disable_all_otps
    OneTimePassword.where(user_id: user_id).update_all(enabled: false)
  end
end
