FactoryBot.define do
  factory :favorite do
    user_id { FactoryBot.create(:user).id }
    post_id { FactoryBot.create(:post).id }
  end
end