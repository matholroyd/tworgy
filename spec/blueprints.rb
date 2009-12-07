require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.name     { Faker::Name.name }
Sham.email    { Faker::Internet.email }
Sham.title    { Faker::Lorem.sentence }
Sham.body     { Faker::Lorem.paragraph }
Sham.country  { Faker::Address.uk_country }
Sham.subject  { Faker::Lorem.sentence }
Sham.password(:unique => false) { 'secret' }

User.blueprint do 
  email
  password
  password_confirmation { password }
end

Tworgy.blueprint do
  user
  name
  slug { Sham.name }
end