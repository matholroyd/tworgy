require 'faker'

# Example
# 
# Sham.name     { Faker::Name.name }
# Sham.email    { Faker::Internet.email }
# Sham.title    { Faker::Lorem.sentence }
# Sham.body     { Faker::Lorem.paragraph }
# Sham.keyword  { Faker::Lorem.words(1).first }
# Sham.country  { Faker::Address.uk_country }
# Sham.company  { Faker::Company.name }
# Sham.text     { Faker::Lorem.sentence }
# Sham.body     { Faker::Lorem.paragraph }
# Sham.subject  { Faker::Lorem.sentence }
# 
# User.blueprint do 
#   name 
#   email 
#   salt { 'salt' }
#   crypted_password { User.password_digest('secret', 'salt') }
#   state { 'active' }
#   default_country_or_region { @country }
#   created_at { 5.days.ago }
#   activated_at { 5.days.ago }
#   remember_token { '77de68daecd823babbb58edb1c8e14d7106e83bb' }
#   remember_token_expires_at { 1.day.from_now }
# end
# 
# JobApplication.blueprint do
#   user
#   title
#   company_name { Sham.company }
#   country_or_region { @country }
#   remuneration_offered { '50' }
#   remuneration_time_unit_id { TimeUnit::Hourly.id }
# end

