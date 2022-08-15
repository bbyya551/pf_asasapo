FactoryBot.define do
  factory :post do
    user#この記述で、user.rbをまるっきり呼び出せる。
    title { Faker::Lorem.characters(number: 5) }
    body { Faker::Lorem.characters(number:20) }
   end
end