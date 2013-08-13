class SessionsController < ApplicationController
  
  layout "admin"
  
  def create
    user = login(params[:email], params[:password], params[:remember_me])
    if user
      redirect_back_or_to admin_dashboard_index_url, notice: I18n.t("auth.welcome_message", user: user.email)
    else
      flash.now.alert = I18n.t("auth.log_in_error_message")
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_url, notice: I18n.t("auth.log_out_error_message")
  end
  
end
