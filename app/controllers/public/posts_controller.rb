class Public::PostsController < ApplicationController
  before_action :correct_user, only: [:edit, :update]

  def new
   @post = Post.new
  end

  def create
    # binding.pry
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    #:genre_nameは、view側で指定できるもの。createした時のターミナルのParameters:を確認。
    @genre_list = params[:post][:genre_name].split(/[[:blank:]]+/).select(&:present?)
    # binding.pry
    if @post.save
      @post.save_genres(@genre_list)
      redirect_to post_path(@post.id), notice: "投稿に成功しました"
    else
      render 'new'
    end
  end

  def index
    @posts = Post.order(created_at: :desc).page(params[:posts_page])
    @user = current_user
    @user_groups = @user.groups.page(params[:user_groups_page]).per(3)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @post_comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])
    @genre_list = @post.genres.map { |genre| genre.name }
  end

  def update
    @post = Post.find(params[:id])
    @genre_list = params[:post][:genre_name].split(/[[:blank:]]+/).select(&:present?)
    if @post.update(post_params)
      @post.update_genres(@genre_list)
      redirect_to post_path(@post.id), notice: "投稿の編集に成功しました"
    else
      render "edit"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました"
  end

  private

  def post_params
    params.require(:post).permit(:post_image, :title, :body)
  end

  def correct_user
    @post = Post.find(params[:id])
    @user = @post.user
    unless @user == current_user
      redirect_to posts_path
    end
  end
end
