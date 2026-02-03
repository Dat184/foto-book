class UserMailer < ApplicationMailer
  default from: email_address_with_name("fotobook@gmail.com", "Foto Book Notifications")
end
