class InstagramTagPage < PageFactory

  element(:most_recent_section) { |b| b.div(data_reactid: /mostRecentSection/) }
  value(:most_recent_photo_id) { |b| b.most_recent_section.when_present.link.href[/(?<=\/p\/)\S+(?=\/)/] }
  value(:last_photo_id) { |b| b.most_recent_section.when_present.link(index: 1).href[/(?<=\/p\/)\S+(?=\/)/] }

end