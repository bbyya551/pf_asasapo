class Public::ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_non_related, only: [:show]

  def show
    @user = User.find(params[:id])
    rooms = current_user.user_rooms.pluck(:room_id) #まずは:user_id: current_user.idが入ってるuser_roomsの:room_idを全て取ってくる
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms) #次に、うえの式で取ってきたuser_roomsの中から、user_idがチャット相手の@user.idであるものを探し出す。

    unless user_rooms.nil?
      #上で探し出したuser_roomsは一つのはず?
      @room = user_rooms.room
    else
      # user_roomsが見つからなければ、@roomを一つ作成
      @room = Room.new
      @room.save
      #user_roomも、user_idがcurrent_user.idと、チャット相手(@user.id)の文をそれぞれ作成
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      User_room.create(user_id: @user.id, room_id: @room.id)
    end
    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    @chat = current_user.chats.new(chat_params)
    render :validater unless @chat.save
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  def reject_non_related
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to posts_path
    end
  end

  # def create
  #   if UserRoom.where(user_id: current_user.id, room_id: params[:chat][:room_id]).present?
  #     @chat = Chat.create(params.require(:chat).permit(:user_id, :message, :room_id).merge(user_id: current_user.id))
  #   else
  #     flash[:notice] = "faild to message"
  #   end
  #   redirect_to room_path(@chat.room_id)
  # end
end
