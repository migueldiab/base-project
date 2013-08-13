class UsersController < ApplicationController

  layout "admin"

  def new    
    @user = User.new
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
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
