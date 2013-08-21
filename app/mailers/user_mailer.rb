class UserMailer < ActionMailer::Base

  default from: I18n.t("app.email")

  def reset_password_email(user)
    @user = user
    @url  = edit_password_reset_url(user.reset_password_token)
    mail(to: user.email, subject: I18n.t("auth.emails.password_reset.subject"))
  end
end
