class WebstaPhotoList < WebstaBase

  value(:photo_id) { |b| b.noko.div(class: 'mainimg_wrapper').link.href[/(?<=\/p\/).+/] }
  value(:user_name) { |b| b.noko.div(class: 'firstinfo').link.text }
  value(:last_user_name) { |b| b.noko.div(class: 'firstinfo', index: 1).link.text }

  p_action(:view_user) { |name, b| b.link(text: name).when_present.click }

  value(:liked?) { |b| b.div(class: 'like_stats clearfix').button(class: 'btn btn-default btn-xs likeButton done').present? }
  p_value(:like_count) { |id, b| b.noko.span(class: "like_count_#{id}").text.to_i }

  element(:photos_wrapper) { |b| b.div(class: 'photos_wrapper') }
  
end