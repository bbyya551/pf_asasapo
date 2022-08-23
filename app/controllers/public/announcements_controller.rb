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
      # @announcements = @user.announcements.order('created_at DESC')
      # # 新着宣言を上から1件取得
      # @announcements_latest1 = @announcements.first(1)
      # # 新着宣言1件を除く全宣言を取得 (1件以下の場合は空)
      # @announcements_offset1 = @announcements.offset(1)
      redirect_to user_path(@user, "tab" => "tab2"), notice: "You have created announcement successfully."
      @user.create_notification_announcement!(current_user, @announcement.id)
      # render 'create'
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
      # @announcements = @user.announcements.order('created_at DESC')
      # # 新着宣言を上から1件取得
      # @announcements_latest1 = @announcements.first(1)
      # # 新着宣言1件を除く全宣言を取得 (1件以下の場合は空)
      # @announcements_offset1 = @announcements.offset(1)
      redirect_to user_path(@user, "tab" => "tab2"), notice: "You have updated unnouncement successfully."
      # render :update
    else
      render "edit"
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    Announcement.find(params[:id]).destroy
    redirect_to user_path(@user, "tab" => "tab3")
  end

  private

  def announcement_params
    params.require(:announcement).permit(:announcement, :achieve_status, :user_id, :start_time)
  end
end
