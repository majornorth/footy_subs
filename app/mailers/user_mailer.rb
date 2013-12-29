class UserMailer < ActionMailer::Base
  SM = "mccoy.stewart@gmail.com"
  default from: SM

  def password_reset(user)
    @user = user
    mail(to: @user.email, subject: "Reset your password for FootySubs",  reply_to: JD, bcc: JD)
  end
end
