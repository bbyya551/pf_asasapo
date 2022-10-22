require 'rails_helper'

RSpec.describe Room, type: :model do
  before do
    @room = FactoryBot.build(:room)
  end

  describe 'アソシエーションのテスト' do
    context 'Chatモデルとの関係' do
      it '1:Nとなっている' do
        expect(Room.reflect_on_association(:chats).macro).to eq :has_many
      end
    end
  end
end