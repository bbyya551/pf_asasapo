FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    introduction { Faker::Lorem.characters(number: 20) }
    password { 'password' }
    password_confirmation { 'password' }

    trait :user_with_groups do
      #多対多のテスト
      #userが作られるとき、自動的にuser.groups(userに紐づいたgroups、すなわちgroup_user)を作るということ
      after(:build) do |user|  # after(:build)とした場合、createの場合もcallbackが走る
        user.groups << build(:group)
      end
    end

    after(:build) do |user|
      user.profile_image.attach(io: File.open('spec/images/profile_image.jpeg'), filename: 'profile_image.jpeg', content_type: 'application/xlsx')
    end
  end
end