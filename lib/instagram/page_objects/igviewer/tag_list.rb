class IGViewerTagList < BasePage

  value(:logged_in?) { |b| b.img(id: 'navbar-avatar').present? }

  action(:log_in) { |b| b.link(href: '/login').click }

  value(:photo_id) { |b| b.noko.span(class: 'gallery-thumbnail').link.href[/(?<=\/)\d.+$/] }
  value(:user_name) { |b| b.noko.div(class: 'media-body').link.text }
  value(:last_user_name) { |b| b.noko.div(class: 'media-body', index: 1).link.text }
  value(:like_count) { |b| b.noko.span(class: 'like-count').text.to_i }
  value(:liked?) { |b| b.span(class: 'gallery-set-like').i.class_name.include? 'gallery-photo-likes' }

  action(:view_user) { |b| b.link(text: b.user_name).click }

end