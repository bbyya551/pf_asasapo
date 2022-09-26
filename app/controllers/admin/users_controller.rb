class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to admin_user_path(@user.id), notice: "会員ステータスを更新しました"
  end

  def index
    @users = User.all
  end

  private

  def user_params
    params.require(:user).permit(:is_deleted)
  end
end
