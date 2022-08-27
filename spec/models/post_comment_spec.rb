#frozen_string_literal: true

require 'rails_helper'
RSpec.describe PostComment, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:post_comment)).to be_valid
    end
  end
  context "空白のバリデーションチェツク" do
    it "commentが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      post_comment = FactoryBot.build(:post_comment, comment: '')
      expect(post_comment).to be_invalid
      expect(post_comment.errors[:comment]).to include("を入力してください")
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(PostComment.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Postモデルとの関係' do
      it 'N:1となっている' do
        expect(PostComment.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
  end
end