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
      #"tab" => "tab2"は、urlに、任意のパラメーターを付与する記述。urlは、/users/1?tab=tab2になり、?tab=tab2が付与される。
      redirect_to user_path(@user, "tab" => "tab2"), notice: "You have created announcement successfully."
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
      redirect_to user_path(@user, "tab" => "tab2"), notice: "You have updated announcement successfully."
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
