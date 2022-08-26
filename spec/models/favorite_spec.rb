require 'rails_helper'

RSpec.describe Favorite, type: :model do
  before do
    user = FactoryBot.create(:user)
    post = FactoryBot.create(:post)
    @favorite = FactoryBot.build(:favorite, user_id: user.id, post_id: post.id)
    # sleep 0.2
  end

  describe 'いいね機能' do
    context 'いいねできる場合' do
      it "user_idとpost_idがあれば保存できる" do
        expect(@favorite).to be_valid
      end

      it "post_idが同じでもuser_idが違えばいいねできる" do
        another_favorite = FactoryBot.create(:favorite)
        expect(FactoryBot.create(:favorite, user_id: another_favorite.user_id)).to be_valid
      end

      it "user_idが同じでもpost_idが違えばいいねできる" do
        another_favorite = FactoryBot.create(:favorite)
        expect(FactoryBot.create(:favorite, post_id: another_favorite.post_id)).to be_valid
      end
    end

    context 'いいねできない場合' do
      it "user_idが空ではいいねできない" do
        @favorite.user_id = nil
        @favorite.valid?
        expect(@favorite.errors.full_messages).to include "Userを入力してください"
      end

      it "post_idが空ではいいねできない" do
        @favorite.post_id = nil
        @favorite.valid?
        expect(@favorite.errors.full_messages).to include "Postを入力してください"
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Favorite.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Postモデルとの関係' do
      it 'N:1となっている' do
        expect(Favorite.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
  end
end