class WebstaFollowers < BasePage

  page_url 'http://websta.me/followed-by/1176600485'

  value(:followers_count) { |b| b.noko.div(class:'userinfo').span(class: 'counts_followed_by').text.groom.to_i }
  value(:followers) { |b| b.noko.ul(class:'userlist').lis.map { |li| li.strong.text.to_sym }.compact }

  element(:next_page_button) { |b| b.link(text: 'Next Page') }

end