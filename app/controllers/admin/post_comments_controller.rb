class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!
  def destroy
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.find_by(id: params[:id], post_id: params[:post_id])
    @post_comment.destroy
  end

  def index
    @post = Post.find(params[:post_id])
  end
end
