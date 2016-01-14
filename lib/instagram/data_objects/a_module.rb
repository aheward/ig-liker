module Share

  def likable?
    cp = @current_photo
    puking_photos = cp[:user]==cp[:last_user]
    already_liked = cp[:liked]
    spammer = cp[:followings]<5
    follower = $followers.keys.include? cp[:user].to_sym
    too_many_likes = cp[:likes]>10

    DEBUG.message 'User posting multiple photos' if puking_photos
    DEBUG.message 'Photo already liked' if already_liked
    DEBUG.message 'Spammer' if spammer
    DEBUG.message "A follower with #{cp[:followers]} followers of their own" if follower
    DEBUG.message 'Photo has too many likes' if too_many_likes

    return false if puking_photos || already_liked || spammer
    return false if follower && !too_many_likes
    return false if too_many_likes && !follower
    true
  end

end