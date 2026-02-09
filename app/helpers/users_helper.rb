module UsersHelper
  def avatar_url(user)
    if user.avatar.blank?
      "https://ui-avatars.com/api/?name=#{user.firstName}+#{user.lastName}&size=256"
    else
      user.avatar.url
    end
  end
end
