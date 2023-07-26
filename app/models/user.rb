class User < ApplicationRecord
  has_one :config, class_name: 'UserConfig', foreign_key: 'user_id', dependent: :destroy

  has_many :api_keys, as: :bearer, dependent: :destroy
  has_many :one_time_passwords, dependent: :destroy

  has_secure_password

  after_create :create_config

  validates :email, uniqueness: true, on: :update

  def authenticate_with_otp(otp:)
    return false unless config.otp_enabled?

    target = one_time_passwords.newest
    return false if target.nil?

    target.verify_with_otp(otp)
  end

  private

  def create_config
    UserConfig.create!(user: self)
  end
end
