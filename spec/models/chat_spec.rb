require 'rails_helper'

RSpec.describe Chat, type: :model do
  before do
    user = FactoryBot.create(:user)
    room = FactoryBot.create(:room)
    @chat = FactoryBot.build(:chat, user_id: user.id, room_id: room.id)
  end

  describe 'アソシエーションのテスト' do
    context 'Roomモデルとの関係' do
      it 'N:1となっている' do
        expect(Chat.reflect_on_association(:room).macro).to eq :belongs_to
      end
    end
  end
end