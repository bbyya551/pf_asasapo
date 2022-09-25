module Public::RoomsHelper
  def most_new_chat_preview(room)
    chat = room.chats.order(updated_at: :desc).limit(1)
    chat = chat[0]

    if chat.present?
      #spanタグを生成(tag.span)
      tag.span "#{ chat.message.truncate(10) }"
    else
      tag.span "まだメッセージはありません"
    end
  end

  def opponent_user(room)
    user_room = room.user_rooms.where.not(user_id: current_user)
    name = user_room[0].user.name
    tag.span "#{name}"
  end
end
