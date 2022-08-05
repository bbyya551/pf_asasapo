class Public::PostCommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.new(post_comment_params)
    @post_comment.user_id = current_user.id
    @post_comment.post_id = @post.id
    @post_comment.save
    redirect_to request.referer
  end

  def destroy
    PostComment.find_by(id: params[:id], post_id: params[:post_id]).destroy
    redirect_to request.referer
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
