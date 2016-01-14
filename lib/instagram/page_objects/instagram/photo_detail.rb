class InstagramPhotoDetail < PageFactory

  element(:user_link) { |b| b.link(data_reactid: '.0.1.0.0.0.0.1.0') }

  value(:user_name) { |b| b.user_link.when_present.title }

  action(:view_user) { |b| b.user_link.when_present.click }

  value(:liked?) { |b| b.link(text: 'Unlike').present? }

  action(:like) { |b| b.link(text: 'Like').when_present.click }

  # If the score is small then there's no number present! Sucky!
  value(:like_score) { |b|
    b.div(data_reactid: '.0.1.0.0.0.2.0.0').wait_until_present
    if b.span(data_reactid: '.0.1.0.0.0.2.0.0.0.1').present?
      b.span(data_reactid: '.0.1.0.0.0.2.0.0.0.1').text.groom
    else
      0
    end
  }

  element(:following_button) { |b| b.button(text: 'Following') }

  value(:photo_date) { |b| b.time.title }

end