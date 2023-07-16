FactoryBot.define do
  factory :one_time_password do
    user { user }
    otp_secret { SecureRandom.hex }
  end
end
