class IconosquareProfile < IconosquareBase

  action(:list_view) { |b| b.link(href: /user.+list$/).click }

  p_element(:tags_div) { |id, b| b.div(data_id: id).div(class: 'detail-tags') }

  p_value(:tags) { |id, b| b.noko.div(data_id: id).div(class: 'detail-tags').links(class: 'unTag').map { |l| l.text } }

end