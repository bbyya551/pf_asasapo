class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]
  before_action :set_user, only: [:favorites]
  before_action :ensure_guest_user, only: [:edit]
  # before_action :set_announcements, only: [:show]

  def show
    @user = User.find(params[:id])
    # @currentUserUserRoom = UserRoom.where(user_id: current_user.id)
    # @userUserRoom = UserRoom.where(user_id: @user.id)
    # unless @user.id == current_user.id
    #   @currentUserUserRoom.each do |cu|
    #     @userUserRoom.each do |u|
    #       if cu.room_id == u.room_id then
    #         @isRoom = true
    #         @roomId = cu.room_id
    #       end
    #     end
    #   end
    #   unless @isRoom
    #     @room = Room.new
    #     @user_room = UserRoom.new
    #   end
    # end

    @posts = @user.posts.order(created_at: :desc).page(params[:posts_page])
    @announcements = @user.announcements.order('created_at DESC')
    # 新着宣言を上から1件取得
    @announcements_latest1 = @announcements.first(1)
    # 新着宣言1件を除く全宣言を取得 (1件以下の場合は空)
    # @announcements_offset1 = @announcements.offset(1)
    # @announcements_offset1 = @announcements.offset(1).page(params[:offset_announce_page]).per(20)
    @announcements_offset1 = @announcements.page(params[:offset_announce_page]).per(20)
    @user_groups = @user.groups.page(params[:user_groups_page]).per(3)
    respond_to do |format|
      format.html
      format.js
    end
    # @user = current_user
    # @announcements = @user.announcements.page(params[:page]).per(3)
    # byebug
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "ユーザー情報の編集に成功しました"
    else
      render "edit"
    end
  end

  def index
    @users = User.where(is_deleted: "false").page(params[:users_page]).per(8)
    @user = current_user
    @user_groups = @user.groups.page(params[:user_groups_page]).per(3)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def favorites
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    # @favorite_posts =
    # favorites.each do |favorite|
    #   favorite_post = Post.where(id: favorite)
    # end
    #whereは複数のidを指定可能
    @favorite_posts = Post.where(id: favorites).order(created_at: :desc).page(params[:favorite_posts_page])
    @user_groups = @user.groups.page(params[:user_groups_page]).per(3)
    respond_to do |format|
      format.html
      format.js
    end
    # @announcements = @user.announcements
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # def set_announcements
  #   @announcements = @user.announcements.order('created_at DESC')
  # end

  def user_params
    params.require(:user).permit(:name, :introduction, :hobby, :profile_image)
  end

  def correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user.id)
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to user_path(current_user), notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません'
    end
  end
end
