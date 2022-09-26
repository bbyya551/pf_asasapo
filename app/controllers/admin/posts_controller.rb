class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    @post_comments = @post.post_comments
    @user = @post.user
  end

  def index
    @posts = Post.order(created_at: :desc)
    # @posts = Post.order(created_at: :desc).page(params[:page]).per(8)
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path, notice: "投稿を削除しました"
  end
end
