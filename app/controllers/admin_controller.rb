class AdminController < ApplicationController
  
  before_filter :require_login
  before_filter :require_admins
  layout "admin"
  
  private
  
  def require_admins
    redirect_to root_url, notice: I18n.t("auth.not_allowed") unless current_user.admin?
  end
  
end
