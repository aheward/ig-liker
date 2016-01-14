class TofoUserProfile < TofoBasePage

  value(:following_count) { |b| b.noko.div(class: 'profileUserStats').div(class: 'statNumber decoration', index: 2).text.to_i }

end