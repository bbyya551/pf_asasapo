#frozen_string_literal: true

require 'rails_helper'
#user_idは定義しなくていいですか
RSpec.describe Post, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    #ここから
    let(:user) { create(:user) }
    let!(:post) { build(:post, user_id: user.id) }
    #ここまではいらないかもしれない

    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:post)).to be_valid
    end
  end
  context "空白のバリデーションチェツク" do
    it "titleが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      #記述はFactoryBotを使用しよう。
      post = FactoryBot.build(:post, title: '', body: 'hoge')
      # post = Post.new(title: '', body: 'hoge')
      expect(post).to be_invalid
      expect(post.errors[:title]).to include("を入力してください")
    end
    it "bodyが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      post = FactoryBot.build(:post, title: 'hoge', body: '')
      # post = Post.new(title: 'hoge', body: '')
      expect(post).to be_invalid
      expect(post.errors[:body]).to include("を入力してください")
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
  end
end