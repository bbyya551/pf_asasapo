FactoryBot.define do
  factory :announcement do
    user#この記述で、spec/factories/user.rbをまるっきり呼び出せる。
    announcement { Faker::Lorem.characters(number: 30) }
   end
end