class UserMailer < ApplicationMailer
  default from: "me@mydomain.com"

  def registration_confirmation(user)
    @user = user
    mail(to: "<#{user.email_address}>", subject: "Registration Confirmation")
  end
end
