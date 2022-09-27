class Public::HomesController < ApplicationController
  def top
    @posts = Post.page(params[:page]).order(created_at: :desc).limit(3)
    @groups = Group.page(params[:page]).order(created_at: :desc).limit(3)
  end
end
