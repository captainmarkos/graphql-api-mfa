class User < ApplicationRecord
  has_one :user_config

  has_many :api_keys, as: :bearer
  has_many :one_time_passwords

  has_secure_password

  after_create :create_user_config

  def otp_enabled?
    user_config.otp_enabled?
  end

  def authenticate_with_otp(otp:)
    return false unless otp_enabled?

    target = one_time_passwords.enabled.first

    target.verify_with_otp(otp)
  end

  private

  def create_user_config
    user_config || UserConfig.create!(user: self)
  end
end
