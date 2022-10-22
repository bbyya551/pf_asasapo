require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "create" do
    context "post関連の通知" do
      before do
        @post = FactoryBot.build(:post)
        @post_comment = FactoryBot.build(:post_comment)
      end

      it "コメントが行われた場合に保存できる" do
        notification = FactoryBot.build(:notification, post_comment_id: @post_comment.id, action: "comment")
        expect(notification).to be_valid
      end

      it "いいねされた場合に保存できる" do
        notification = FactoryBot.build(:notification, post_id: @post.id, action: "Like")
        expect(notification).to be_valid
      end
    end

    context "フォロー関連の通知" do
      it "フォローが行われた場合に保存できる" do
        user1 = FactoryBot.build(:user)
        user2 = FactoryBot.build(:user)
        notification = FactoryBot.build(:notification, visitor_id: user1.id, visited_id: user2.id, action: "follow")
        expect(notification).to be_valid
      end
    end

    context "朝活宣言の通知" do
      it "朝活宣言が行われた場合に保存できる" do
        @announcement = FactoryBot.build(:announcement)
        notification = FactoryBot.build(:notification, announcement_id: @announcement.id, action: "announcement")
        expect(notification).to be_valid
      end
    end

    context "チャットの通知" do
      it "チャットが送信された場合に保存できる" do
        @chat = FactoryBot.build(:chat)
        # @room = FactoryBot.build(:room)
        @room = @chat.room
        notification = FactoryBot.build(:notification, chat_id: @chat.id, room_id: @room.id, action: "dm")
        expect(notification).to be_valid
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it 'N:1となっている' do
        expect(Notification.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end

    context 'PostCommentモデルとの関係' do
      it 'N:1となっている' do
        expect(Notification.reflect_on_association(:post_comment).macro).to eq :belongs_to
      end
    end

    context 'Announcementモデルとの関係' do
      it 'N:1となっている' do
        expect(Notification.reflect_on_association(:announcement).macro).to eq :belongs_to
      end
    end
  end
end

