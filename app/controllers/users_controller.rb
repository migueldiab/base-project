class UsersController < ApplicationController

  #before_filter :set_user_to_user_info, only: [:create]

  def new
    @user = User.new
    @user.user_info = UserInfo.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to root_url, notice: I18n.t("auth.successful_message")
    else
      render :new
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, user_info_attributes: [:first_name, :last_name])
  end

end
