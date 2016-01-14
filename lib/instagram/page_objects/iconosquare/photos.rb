class IconosquarePhotos < IconosquareBase

  expected_element :photos_wrapper

  action(:more) { |b| b.link(text: 'More').click }
  action(:view_user) { |b| b.div(class: 'photos-wrapper').div(class: 'pseudo').link.click }

end