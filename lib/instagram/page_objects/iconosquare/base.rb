class IconosquareBase < BasePage

  element(:photos_wrapper) { |b| b.div(class: 'photos-wrapper') }
  p_value(:like_score) { |photo_id, b| b.noko.div(id: "detailPhoto-#{photo_id}").span(class: 'nb_like_score').text.to_i }
  p_value(:user_name) { |photo_id, b| b.noko.div(id: "detailPhoto-#{photo_id}").div(class: 'pseudo').link.text }
  value(:photo_ids) { |b| b.noko.divs(class: 'photos-wrapper').map{ |div| div.id[/\d+_\d+/] }.compact }
  p_value(:liked?) { |photo_id, b| b.noko.link(id: "like-#{photo_id}").class_name=~/unlikeAction/ }
  p_action(:like) { |photo_id, b| b.link(id: "like-#{photo_id}").click }

  element(:get_yours_button) { |b| b.div(id: 'key-metrics').link(text: 'get yours') }

end