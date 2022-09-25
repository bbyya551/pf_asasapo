class Public::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def new
    @group = Group.new
  end

  def index
    @groups = Group.order(created_at: :desc).page(params[:groups_page]).per(3)
    @user = current_user
    @user_groups = @user.groups.page(params[:user_groups_page]).per(3)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @group = Group.find(params[:id])
    #whereでとってきた値は、一つでも必ず配列になる。
    # @group_user = @group.group_users.where(user_id: @group.owner_id)
    #もしこの記述で書くのであれば、@owner = User.find(@group_user[0].user_id)とかもしくは@owner = User.find(@group_user.first.user_id)にしないといけない!!
    @owner = User.find(@group.owner_id)
    @review = Review.new
  end

  def create
    # binding.pry
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @tag_list = params[:group][:tag_name].split(/[[:blank:]]+/).select(&:present?)
    if @group.save
      @group.save_tags(@tag_list)
      redirect_to group_path(@group), notice: "コミュニティの作成に成功しました"
    else
      render 'new'
    end
  end

  def edit
    # binding.pry
    @group = Group.find(params[:id])
    @tags = @group.tags.map { |tag| tag.name }
  end

  def update
    @group = Group.find(params[:id])
    # @tags = @group.tags.map { |tag| tag.name }
    # binding.pry
    @tag_list = params[:group][:tag_name].split(/[[:blank:]]+/).select(&:present?)
    if @group.update(group_params)
      @group.update_tags(@tag_list)
      redirect_to group_path(@group.id), notice: "コミュニティの編集に成功しました"
    else
      render "edit"
    end
  end

  def new_mail
    @group = Group.find(params[:group_id])
  end

  def send_mail
    @group = Group.find(params[:group_id])
    group_users = @group.users
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]
    ContactMailer.send_mail(@mail_title, @mail_content, group_users).deliver
  end

  def tags
    @tags = Tag.all
    @user = current_user
    @user_groups = @user.groups.page(params[:user_groups_page]).per(3)
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def group_params
    # params.require(:group).permit(:name, :introduction, :image, tags_attributes: [:group][:id, :tag_name])
    params.require(:group).permit(:name, :introduction, :image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end
