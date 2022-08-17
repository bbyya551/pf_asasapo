FactoryBot.define do
  factory :group do
    # user
    name { Faker::Lorem.characters(number: 5) }
    introduction { Faker::Lorem.characters(number:20) }

    after(:build) do |group|
      group.image.attach(io: File.open('spec/images/profile_image.jpeg'), filename: 'profile_image.jpeg', content_type: 'application/xlsx')
    end
  end
end