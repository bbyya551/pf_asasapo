require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:relationship) { FactoryBot.create(:relationship) }
  describe '#create' do
    context "保存できる場合" do
      it "全てのパラメーターが揃っていれば保存できる" do
        expect(relationship).to be_valid
      end
    end

    context "保存できない場合" do
      it "follower_idがnilの場合は保存できない" do
        relationship.follower_id = nil
        relationship.valid?
        expect(relationship.errors[:follower_id]).to include("を入力してください")
      end

      it "followed_idがnilの場合は保存できない" do
        relationship.followed_id = nil
        relationship.valid?
        expect(relationship.errors[:followed_id]).to include("を入力してください")
      end
    end

    context "一意性の検証" do
      before do
        @relation = FactoryBot.create(:relationship)
        @user1 = FactoryBot.build(:relationship)
      end
      it "follower_idとfollowed_idの組み合わせは一意でなければ保存できない" do
        relation2 = FactoryBot.build(:relationship, follower_id: @relation.follower_id, followed_id: @relation.followed_id)
        relation2.valid?
        expect(relation2.errors[:follower_id]).to include("はすでに存在します")
      end

      it "follower_idが同じでもfollowed_idが違うなら保存できる" do
        relation2 = FactoryBot.build(:relationship, follower_id: @relation.follower_id, followed_id: @user1.followed_id)
        expect(relation2).to be_valid
      end

      it "follower_idが違うならfollowed_idが同じでも保存できる" do
        relation2 = FactoryBot.build(:relationship, follower_id: @user1.follower_id, followed_id: @relation.followed_id)
        expect(relation2).to be_valid
      end
    end
  end

  describe "各モデルとのアソシエーション" do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "仮想モデルfollowerとのアソシエーション" do
      let(:target) { :follower }

      it "Followerとの関連付けはbelongs_toであること" do
        expect(association.macro).to  eq :belongs_to
      end
    end

    context "仮想モデルfollowedとのアソシエーション" do
      let(:target) { :followed }

      it "Followedとの関連付けはbelongs_toであること" do
        expect(association.macro).to  eq :belongs_to
      end
    end
  end
end