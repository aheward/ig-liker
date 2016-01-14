class CollectoBase < BasePage

  page_url 'http://collec.to'

  action(:sign_in) { |b| b.sign_in_button.when_present.click }

  element(:sign_in_button) { |b| b.button(text: 'Sign in with Instagram') }

  element(:nav_profile) { |b| b.div(class: 'nav-profile') }

end