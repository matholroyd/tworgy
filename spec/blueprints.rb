require 'faker'

Sham.name     { Faker::Name.name }
Sham.email    { Faker::Internet.email }
Sham.title    { Faker::Lorem.sentence }
Sham.body     { Faker::Lorem.paragraph }
Sham.country  { Faker::Address.uk_country }
Sham.subject  { Faker::Lorem.sentence }

User.blueprint do 
  name 
  email 
  salt { 'salt' }
  crypted_password { User.password_digest('secret', 'salt') }
  state { 'active' }
  created_at { 5.days.ago }
  activated_at { 5.days.ago }
  remember_token { '77de68daecd823babbb58edb1c8e14d7106e83bb' }
  remember_token_expires_at { 1.day.from_now }
end

