class Admin::UsersController < AdminController

  def index
    @users = User.unscoped.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_url, notice: I18n.t("admin.messages.successful_creation", resource: I18n.t("admin.users.resource_name"))
    else
      render :new
    end
  end
  
  def edit
    @user = User.unscoped.find(params[:id])
  end
  
  def update
    @user = User.unscoped.find(params[:id])
    if @user.update_attributes user_params
      redirect_to admin_users_url, notice: I18n.t("admin.messages.successful_edition", resource: I18n.t("admin.users.resource_name"), name: @user.email)
    else
      render :edit
    end
  end
  
  def destroy
    @user = User.unscoped.find(params[:id])

    redirect_to admin_users_url, notice: I18n.t("admin.users.errors.delete_yourself", resource: I18n.t("admin.users.resource_name"), name: @user.email) and return if @user == current_user

    if @user.update_attribute :deleted, true
      redirect_to admin_users_url, notice: I18n.t("admin.messages.successful_removal", resource: I18n.t("admin.users.resource_name"), name: @user.email)
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role, :deleted)
  end
end
