#frozen_string_literal: true

require 'rails_helper'

RSpec.describe Genre, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do

    it "有効な内容の場合は保存されるか" do
      expect(FactoryBot.build(:genre)).to be_valid
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it '1:Nとなっている' do
        expect(Genre.reflect_on_association(:posts).macro).to eq :has_many
      end
    end
  end
end