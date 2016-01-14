class WebstaUserDetail < WebstaBase

  value(:following) { |b| b.noko.span(class: 'following').text.to_i }

  p_action(:like) { |id, b| b.button(data_target: id).when_present.click }

end