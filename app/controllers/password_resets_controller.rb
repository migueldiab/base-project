class PasswordResetsController < ApplicationController

  # request password reset.
  # you get here when the user entered his email in the reset password form and submitted it.
  def create
    @user = User.find_by_email(params[:email])

    if @user
      # This line sends an email to the user with instructions on how to reset their password (a url with a random token)
      @user.deliver_reset_password_instructions!

      # Tell the user instructions have been sent whether or not email was found.
      # This is to not leak information to attackers about which emails exist in the system.
      redirect_to(root_path, notice: I18n.t("auth.password_reset.success"))
    else
      flash.now.alert = I18n.t("auth.password_reset.user_not_found", email: params[:email])
      render :new
    end
  end

  # This is the reset password form.
  def edit
    @user = User.load_from_reset_password_token(params[:id])
    @token = params[:id]
    not_authenticated unless @user
  end

  # This action fires when the user has sent the reset password form.
  def update
    @token = params[:token]
    @user = User.load_from_reset_password_token(params[:token])
    not_authenticated and return unless @user
    # the next line makes the password confirmation validation work
    @user.password_confirmation = params[:user][:password_confirmation]
    # the next line clears the temporary token and updates the password
    if password_and_confirmation_not_blank && @user.change_password!(params[:user][:password])
      redirect_to(root_path, notice: I18n.t("auth.password_reset.reset_success"))
    else
      # I'm manually doing this because the validation is only at creation not for updates.
      # I want it this way so users can save his data without the need of updating the password every time
      @user.errors[:password] = I18n.t("activerecord.errors.models.user.attributes.password.blank") if params[:user][:password].blank?
      @user.errors[:password_confirmation] = I18n.t("activerecord.errors.models.user.attributes.password_confirmation.blank") if params[:user][:password_confirmation].blank?

      render :action => "edit"
    end
  end

  private

  def password_and_confirmation_not_blank
    !params[:user][:password].blank? && !params[:user][:password_confirmation].blank?
  end

end
