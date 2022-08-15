FactoryBot.define do
  factory :group do
    # user
    name { Faker::Lorem.characters(number: 5) }
    introduction { Faker::Lorem.characters(number:20) }
   end
end