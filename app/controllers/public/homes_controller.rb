class Public::HomesController < ApplicationController
  def top
    @posts = Post.page(params[:page])
    @groups = Group.page(params[:page]).per(5)
  end
end
