# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :user_state, only: [:create]
  # GET /resource/sign_in
  # def new
  #   super
  # end

  def after_sign_in_path_for(resource)
    user_path(current_user)
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  protected

  def user_state
    @user = User.find_by(email: params[:user][:email])
    return if !@user
    if @user.valid_password?(params[:user][:password]) && @user.is_deleted == true
      redirect_to new_user_registration_path, notice: "このアカウントは現在、サービスを利用できません"
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
