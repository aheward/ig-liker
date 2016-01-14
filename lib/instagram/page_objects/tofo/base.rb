class TofoBasePage < BasePage

  element(:sign_in_link) { |b| b.link(text: 'Sign in with Instagram') }
  action(:sign_in) { |b| b.sign_in_link.click if b.sign_in_link.present? }

  element(:image) { |b| b.div(class:'pic') }
  value(:photo_id) { |b| b.div(class: 'row wall').div.id[/(?<=brick-).*/] }

  p_action(:like) { |id, b| b.photo_div(id).div(class: 'pic').hover; b.photo_div(id).button(title: 'Like').when_present.click }
  value(:liked?) { |b| b.div(class: 'stats').span(class: 'likesCount').style=~/isliked.png/ }
  value(:like_count) { |b| b.noko.div(class:'stats').span(class:'likesCount').text.to_i }

  p_element(:photo_div) { |id, b| b.div(id: "brick-#{id}") }

end