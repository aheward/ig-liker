Given /^I log in$/ do
  visit IconosquareFollowers
  on Login do |page|
    page.username.set ENV['USER']
    page.password.set ENV['PASS']
    begin
      page.log_in
    rescue
      @browser.goto 'http://iconosquare.com/viewer.php'
    end
  end
end

And /^I get all my followers$/ do
  @icono = Iconosquare.new(@browser)
  @icono.get_followers
  #@icono.get_followings
  $followers = @icono.followers
  #$followings = @icono.followings.shuffle
  #$unfollowed = []

  #@popularity = {}
=begin
  $followers.keys.each do |user|
    begin
      Timeout::timeout(5) do
        @browser.goto "https://instagram.com/#{user}/"
      end
    rescue Timeout::Error => msg
      DEBUG.message "Recovered from Timeout"
    end
    begin
      on InstagramProfile do |page|
        DEBUG.message "#{user} - #{page.followers}"
        @popularity[user] = page.followers
      end
    rescue
      # Figure out what to do here...
      @browser.refresh
    end
  end
=end
end

And /I like photos all over the place/ do
  sites = []
  %w{
     InstagramObject
  }.each { |s| sites << Object.const_get(s).new(@browser) }
  sites.shuffle!
  while sites[0].count < 3000 do
    sites.each do |site|
      until $switch do
        Instagram::TAGS.shuffle.each do |tag|
          site.script(tag)
          if $switch
            puts Time.now.to_s
            break
          end
        end
        #if $followings.empty?
        #  $followings = @icono.followings.shuffle - $unfollowed
        #  site.like_a_following($followings.pop)
        #else
        #  subset = $followings.pop(3).compact
        #  DEBUG.inspect subset
        #  subset.each { |user| site.like_a_following(user) }
        #end
      end
      DEBUG.message ''
      DEBUG.message Time.now.to_s
      DEBUG.message ''
      $switch = false
    end
  end
end