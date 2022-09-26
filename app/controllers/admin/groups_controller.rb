class Admin::GroupsController < ApplicationController
  def index
    @groups = Group.order(created_at: :desc)
  end

  def show
    @group = Group.find(params[:id])
    @owner = User.find(@group.owner_id)
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to admin_groups_path, notice: "コミュニティを削除しました"
  end
end
