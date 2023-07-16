class User < ApplicationRecord
  has_one :config, class_name: 'UserConfig', foreign_key: 'user_id', dependent: :destroy

  has_many :api_keys, as: :bearer, dependent: :destroy
  has_many :one_time_passwords, dependent: :destroy

  has_secure_password

  after_create :create_config

  validates :email, uniqueness: true

  def otp_enabled?
    config.otp_enabled?
  end

  def authenticate_with_otp(otp:)
    return false unless otp_enabled?

    target = one_time_passwords.active

    target.verify_with_otp(otp)
  end

  private

  def create_config
    UserConfig.create!(user: self)
  end
end
