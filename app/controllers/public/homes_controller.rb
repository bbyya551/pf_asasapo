class Public::HomesController < ApplicationController
  def top
    @posts = Post.page(params[:page]).order(created_at: :desc)
    @groups = Group.page(params[:page]).order(created_at: :desc).per(3)
  end
end
