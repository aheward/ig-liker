class InstagramFeedPage < BasePage

  expected_element :feed

  page_url 'https://instagram.com'

  element(:feed) { |b| b.div(data_reactid: '.0.1.0.1.0') }

  value(:liked?) { |b| b.feed.link(text: 'Unlike').present? }

  action(:like) { |b| b.feed.link(text: 'Like').when_present.click }

end