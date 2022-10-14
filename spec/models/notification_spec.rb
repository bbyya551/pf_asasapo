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
  end
end

