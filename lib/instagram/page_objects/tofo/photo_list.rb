class TofoPhotoList < TofoBasePage

  value(:poster_name) { |b| b.noko.div(class: 'userName').link.text }
  value(:prior_poster_name) { |b| b.noko.div(class: 'userName', index: 1).link.text }

end