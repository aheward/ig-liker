class IGViewerUser < BasePage

  p_value(:following) { |user, b| b.link(href: "/#{user}/following").text.gsub(' ', '').to_i }
  p_action(:like) { |user, id, b| b.i(data_url: "/#{user}/#{id}").click }

end