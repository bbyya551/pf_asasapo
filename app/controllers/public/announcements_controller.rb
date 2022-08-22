class Public::AnnouncementsController < ApplicationController

  def new
    @user = User.find(params[:user_id])
    @announcement = Announcement.new
  end

  def create
    @user = User.find(params[:user_id])
    @announcement = Announcement.new(announcement_params)
    @announcement.user_id = @user.id
    if @announcement.save
      redirect_to user_path(@user), notice: "You have created announcement successfully."
      @user.create_notification_announcement!(current_user, @announcement.id)
    else
      render 'new'
    end
  end

  def edit
    # binding.pry
    @user = User.find(params[:user_id])
    @announcement = Announcement.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @announcement = Announcement.find(params[:id])
    if @announcement.update(announcement_params)
      redirect_to user_path(@user), notice: "You have updated unnouncement successfully."
    else
      render "edit"
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    Announcement.find(params[:id]).destroy
    redirect_to user_path(@user.id)
  end

  private

  def announcement_params
    params.require(:announcement).permit(:announcement, :achieve_status, :user_id, :start_time)
  end
end
