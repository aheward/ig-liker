class WebstaLogin < BasePage

  element(:log_in_link) { |b| b.link(text: 'LOG IN') }
  action(:log_in) { |b| b.log_in_link.click }

end