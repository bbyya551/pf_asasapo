class Public::ChatsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    if UserRoom.where(user_id: current_user.id, room_id: params[:chat][:room_id]).present?
      @chat = Chat.create(params.require(:chat).permit(:user_id, :message, :room_id).merge(user_id: current_user.id))
    else
      flash[:notice] = "faild to message"
    end
    redirect_to room_path(@chat.room_id)
  end
end
