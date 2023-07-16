FactoryBot.define do
  factory :user do
    email { "#{SecureRandom.hex}@woohoo.com" }
    password { 'topsecret' }
  end
end
