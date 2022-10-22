FactoryBot.define do
  factory :chat do
    user
    room
    message { Faker::Lorem.characters(number: 5) }
  end
end