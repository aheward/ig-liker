class WebstaBase < BasePage

  expected_element :photo_box

  element(:photo_box) { |b| b.div(class: 'photobox') }

end