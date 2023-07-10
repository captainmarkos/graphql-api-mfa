# db/seeds.rb

emails = ['foo@manchoo.com', 'woohoo@yahoo.com']

emails.each do |email|
  user = User.create!(email: email, password: 'topsecret')
  user.api_keys.create!(token: SecureRandom.hex)
end
