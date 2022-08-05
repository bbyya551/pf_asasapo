class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
    # @user = current_user
    @announcements = @user.announcements
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  def index
    @users = User.all
    @user = current_user
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :hobby, :profile_image)
  end

  def correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user.id)
    end
  end
end
