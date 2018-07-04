class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: (t "mailer.user_mailer.account_activation")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: (t "activations.edit.password_reset")
  end
end
