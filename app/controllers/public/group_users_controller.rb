class Public::GroupUsersController < ApplicationController
  before_action :authenticate_user!

  def create
    @group = Group.find(params[:group_id])
    group_user = current_user.group_users.new(group_id: params[:group_id])
    group_user.save
  end

  def destroy
    @group = Group.find(params[:group_id])
    group_user = current_user.group_users.find_by(group_id: params[:group_id])
    group_user.destroy
  end
end
