class Public::ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  def index
    @group = Group.find(params[:group_id])
    @reviews = @group.reviews
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    if @review.save
      redirect_to group_reviews_path(@review.group)
    else
      @group = Group.find(params[:group_id])
      @owner = User.find(@group.owner_id)
      render "public/groups/show"
    end
  end

  private

  def review_params
    params.require(:review).permit(:group_id, :score, :content)
  end
end
