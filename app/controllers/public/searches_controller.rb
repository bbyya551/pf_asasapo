class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == 'user'
      @records = User.search_for(@content, @method)
    elsif @model == 'post'
      @records = Post.search_for(@content, @method)
    elsif @model == 'group'
      @records = Group.search_for(@content, @method)
    elsif @model == 'genre'
      @records = Genre.search_posts_for(@content, @method)
    end
  end
end