#frozen_string_literal: true

require 'rails_helper'
#user_idは定義しなくていいですか
RSpec.describe Announcement, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    #ここから
    let(:user) { create(:user) }
    #ここまではいらないかもしれない

    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:announcement)).to be_valid
    end
  end
  context "空白のバリデーションチェツク" do
    it "announcementが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      #記述はFactoryBotを使用しよう。
      announcement = FactoryBot.build(:announcement, announcement: '')
      # post = Post.new(title: '', body: 'hoge')
      expect(announcement).to be_invalid
      expect(announcement.errors[:announcement]).to include("を入力してください")
    end
    it '50文字以下であること: 50文字は〇' do
      announcement = FactoryBot.build(:announcement, announcement: 'aaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeee')
      expect(announcement).to be_valid
    end
    it '50文字以下であること: 51文字は×' do
      announcement = FactoryBot.build(:announcement, announcement: 'aaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeef')
      expect(announcement).to be_invalid
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Announcement.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
  end
end