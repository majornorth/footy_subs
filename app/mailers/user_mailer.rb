class UserMailer < ActionMailer::Base
  SM = "mccoy.stewart@gmail.com"
  default from: SM

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to FootySubs",  reply_to: SM, bcc: SM)
  end
end
