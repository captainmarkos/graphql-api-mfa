class OneTimePassword < ApplicationRecord
  OTP_ISSUER = 'Calypso'

  belongs_to :user

  before_create :generate_otp_secret

  validates :user, presence: true

  scope :enabled, -> { where(enabled: true) }
  scope :active, -> { enabled.first }
  scope :recent, -> { order(created_at: :desc).first }

  def verify_with_otp(otp)
    totp = ROTP::TOTP.new(otp_secret, issuer: OTP_ISSUER)

    totp.verify(otp.to_s)
  end

  private

  def generate_otp_secret
    self.otp_secret = ROTP::Base32.random
  end
end
