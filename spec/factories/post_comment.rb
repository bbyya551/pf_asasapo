FactoryBot.define do
  factory :post_comment do
    comment  { Faker::Lorem.characters(number: 5) }
    user
    post
  end
end