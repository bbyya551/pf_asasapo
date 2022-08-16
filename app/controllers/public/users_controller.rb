class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]
  before_action :set_user, only: [:favorites]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page])
    # @user = current_user
    @announcements = @user.announcements
    # byebug
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
    @users = User.where(is_deleted: "false")
    @user = current_user
  end

  def favorites
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    # @favorite_posts =
    # favorites.each do |favorite|
    #   favorite_post = Post.where(id: favorite)
    # end
    #whereは複数のidを指定可能
    @favorite_posts = Post.where(id: favorites).page(params[:page])
    @announcements = @user.announcements
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

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
