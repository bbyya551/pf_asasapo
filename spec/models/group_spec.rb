#frozen_string_literal: true

require 'rails_helper'
#owner_idは定義しなくていいですか
RSpec.describe Group, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    let(:user) { create(:user) }
    let!(:group) { build(:group, owner_id: user.id) }

    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:group)).to be_valid
    end
  end
  context "空白のバリデーションチェック" do
    it "nameが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      group = FactoryBot.build(:group, name: '', introduction: 'hoge')
      expect(group).to be_invalid
      expect(group.errors[:name]).to include("を入力してください")
    end
    it "introductionが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      group = FactoryBot.build(:group, name: 'hoge', introduction: '')
      expect(group).to be_invalid
      expect(group.errors[:introduction]).to include("を入力してください")
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it '1:Nとなっている' do
        expect(Group.reflect_on_association(:users).macro).to eq :has_many
      end
    end
  end
end