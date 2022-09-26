class Public::RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    #joinsはテーブル同士を結合してくれる。left_joinsは外部結合(nilでもnilとしてテーブルを結合してくれる)。joinsは内部結合。
    #byebug
    #@rooms = @user.rooms.left_joins(:chats).includes(:chats).group("chats.room_id").order("chats.created_at DESC")
    #@rooms = @user.rooms.left_joins(:chats).includes(:chats).group("chats.user_id, chats.room_id").order("chats.created_at DESC")

    @rooms = @user.rooms.joins(:chats).includes(:chats).order("chats.created_at DESC")
    #idでグルーピングしてやる
    #@rooms = @user.rooms.left_joins(:chats).group(:id).includes(:chats).order("chats.created_at DESC")
    #@rooms = @user.rooms.left_joins(:chats).group("id").includes(:chats).order("chats.created_at DESC")
    # @rooms = @user.rooms
  end



    # def create
  #   @room = Room.create
  #   @user_room1 = UserRoom.create(room_id: @room.id, user_id: current_user.id)
  #   @user_room2 = UserRoom.create(params.require(:user_room).permit(:user_id, :room_id).merge(room_id: @room.id))
  #   redirect_to room_path(@room.id)
  # end

  # def show
  #   @room = Room.find(params[:id])
  #   if UserRoom.where(user_id: current_user.id, room_id: @room.id).present?
  #     @chats = @room.chats
  #     @chat = Chat.new
  #     @user_rooms = @room.user_rooms
  #   else
  #     redirect_to request.referer
  #   end
  # end
end
