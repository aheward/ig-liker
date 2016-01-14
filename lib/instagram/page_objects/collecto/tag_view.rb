class CollectoTagView < BasePage

  expected_element :author

  element(:nav_profile) { |b| b.div(class: 'nav-profile') }

  value(:photo_id) { |b| b.noko.div(id: 'feedtag').link.href[/(?<=\/i\/).+/] }
  value(:user_name) { |b| b.noko.div(class: 'slideshow_unit_stream_compact').div(class: 'followgram-author-small').link.href[/(?<=\/).+/] }
  value(:last_user_name) { |b| b.noko.div(class: 'slideshow_unit_stream_compact', index: 1).div(class: 'followgram-author-small').link.href[/(?<=\/).+/] }
  value(:like_count) { |b| b.hoover; b.button(class: /likebutton$/, photoid: b.photo_id).text.to_i }
  value(:liked?) { |b|  b.hoover; b.button(class: 'btn btn-small unlikebutton', photoid: b.photo_id).present? }

  action(:hoover) { |b| b.div(class: 'unit_stream_compact_image').hover }

  p_action(:like) { |id, b| b.link(href: "/i/#{id}").hover; b.button(photoid: id, class: 'btn btn-small likebutton').click }

  action(:view_poster) { |b| b.link(href: "/#{b.user_name}").click; b.div(id: 'loading').wait_while_present }

  value(:followings) { |b| b.noko.ul(class: 'countProfileModal').li(index: 1).text[/\d+/].to_i }

  action(:close_modal) { |b| b.div(class: 'modal-footer').button(text: 'Close').click }

  element(:author) { |b| b.div(class: 'followgram-author-small') }
  element(:sidebar) { |b| b.div(class: 'sidebar') }

end