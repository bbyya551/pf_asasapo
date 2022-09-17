FactoryBot.define do
  factory :group do
    # user
    name { Faker::Lorem.characters(number: 5) }
    introduction { Faker::Lorem.characters(number:20) }
    owner_id { 1 }

    trait :group_with_users do
      #多対多のテスト
      after(:build) do |group|
        group.users << build(:user)
      end
    end

    after(:build) do |group|
      group.image.attach(io: File.open('spec/images/profile_image.jpeg'), filename: 'profile_image.jpeg', content_type: 'application/xlsx')
    end
  end
end