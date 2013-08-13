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
      redirect_to admin_users_url, notice: I18n.t("admin.messages.successful_creation", resource: "usuario")
    else
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes user_params
      redirect_to admin_users_url, notice: I18n.t("admin.messages.successful_edition", resource: "usuario", name: @user.email)
    else
      render :edit
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.update_attribute :deleted, true
      redirect_to admin_users_url, notice: I18n.t("admin.messages.successful_removal", resource: "usuario", name: @user.email)
    else
      render :index
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end
end
