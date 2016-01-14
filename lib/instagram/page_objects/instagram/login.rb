class Login < PageFactory

  page_url 'https://instagram.com/accounts/login/?force_classic_login='

  element(:username) { |b| b.text_field(id: 'id_username') }
  element(:password) { |b| b.text_field(id: 'id_password') }
  action(:log_in) { |b| b.button(value: 'Log in').click }
  element(:log_out) { |b| b.link(text: 'Log out').click }

end

class NonClassicLogin < PageFactory

  element(:username) { |b| b.text_field(name:'username') }
  element(:password) { |b| b.text_field(name: 'password') }
  action(:log_in) { |b| b.button(value: 'Log in').click }

end