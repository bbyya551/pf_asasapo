class Public::FavoritesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.new(post_id: @post.id)
    @favorite.save
    redirect_to request.referer
  end

  def destroy
  end
end
