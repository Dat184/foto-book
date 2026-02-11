class UserMailer < ApplicationMailer
  def delete_mail(user)
    @user = user
    mail(to: @user.email, subject: "Your Fotobook account is deleted by Admin")
  end

  def inactive_mail(user)
    @user = user
    mail(to: @user.email, subject: "Your Fotobook account is inactive by Admin")
  end
end