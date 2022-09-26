class Admin::ReviewsController < ApplicationController
  def index
    @group = Group.find(params[:group_id])
    @reviews = @group.reviews
  end

  def destroy
   @group = Group.find(params[:group_id])
   @review = Review.find_by(id: params[:id], group_id: params[:group_id])
   @review.destroy
   redirect_to admin_group_reviews_path, notice: "レビューを削除しました"
  end
end