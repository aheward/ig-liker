class IconosquareFollowers < IconosquareBase

  page_url 'http://iconosquare.com/viewer.php#/myFollowers/'

  value(:followers) { |b| b.noko.divs(class: 'photos-wrapper detailUser').map{ |div| div.p(class:'name').link.text.to_sym }.compact }
  value(:followings) { |b| b.noko.divs(class: 'photos-wrapper detailUser').map{ |div| div.p(class:'name').link.text }.compact }

  element(:more_button) { |b| b.link(text: 'More') }
  action(:more) { |b| b.more_button.when_present.click }
  element(:try_again_button) { |b| b.link(id:'viewerErrorTryAgain') }
  action(:try_again) { |b| b.try_again_button.click }

  element(:user_buttons) { |b| b.div(id: 'userProfilLarge') }
  value(:followers_count) { |b| b.user_buttons.link(class: /followers/).span(class: 'chiffre').text.to_i }
  value(:followings_count) { |b| b.user_buttons.link(class: /followings/).span(class: 'chiffre').text.to_i }

end

class IconosquareUser < IconosquareBase

  expected_element :user_buttons

  element(:user_buttons) { |b| b.div(id: 'userProfilLarge') }
  value(:followings) { |b| b.user_buttons.link(class: /followings/).span(class: 'chiffre').text.to_i }

end