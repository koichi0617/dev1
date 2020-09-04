class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "アカウント認証"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "パスワードリセット"
  end
end
