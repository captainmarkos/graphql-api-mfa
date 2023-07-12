class User < ApplicationRecord
  has_many :api_keys, as: :bearer
  has_many :one_time_passwords

  has_secure_password

  def otp_enabled?
    one_time_passwords.enabled.any?
  end

  def authenticate_with_otp(otp:)
    return false unless otp_enabled?

    target = one_time_passwords.enabled.first

    target.verify_with_otp(otp)
  end
end
