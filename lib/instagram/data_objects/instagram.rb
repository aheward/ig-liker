class InstagramObject < DataFactory

  include Share

  attr_accessor :count

  def initialize(browser, opts={})
    @browser = browser
    @last_photo = {}
    @last_user = {}
    @count = 0
    Instagram::TAGS.each { |t|
      @last_photo.store(t.to_sym, nil)
      @last_user.store(t.to_sym, nil)
    }
  end

  def script(tag)
    begin
      view(tag)
      same_as_before = @last_photo[tag.to_sym] == on(InstagramTagPage).most_recent_photo_id
      puts 'Already dealt with photo' if same_as_before
      return if same_as_before
      get_photo_info
      return if @last_user[tag.to_sym] == @current_photo[:user]
      like
      @last_photo[tag.to_sym] = @current_photo[:id]
      @last_user[tag.to_sym] = @current_photo[:user]
    rescue Exception => e
      puts 'Instagram'
      puts e.message
      e.backtrace.each { |line| puts line }
      sleep 4
    end
    $switch = true if @count > $count_limit
  end

  def view(tag)
    puts Time.now.to_s + " Going to #{tag}..."
    begin
      Timeout::timeout(8) do
        @browser.goto "https://instagram.com/explore/tags/#{tag}/"
      end
    rescue Timeout::Error => msg
      @browser.execute_script('window.stop();')
      puts "Recovered from Timeout"
    end
    log_in if @browser.link(text: 'Log in').present?
    on(InstagramTagPage).most_recent_section.when_present.click
  end

  def like
    if likable?
      view_photo @current_photo[:id]
      on InstagramPhotoDetail do |page|
        puts 'Liking...'
        page.like
        sleep 2
        unless page.liked?
          $switch = true
          puts 'Like was rejected!'
          return
        end
        @count += 1
        puts "#{@count} photos liked"
        puts 'snoozing...'
        sleep rand(3)
      end
    end
  end

  def like_a_following(user)
    view_user user
    begin
      Timeout::timeout(8) {view_photo(on(InstagramTagPage).most_recent_photo_id)}
    rescue Timeout::Error => msg
      return
    end
    on InstagramPhotoDetail do |page|
      date = Date.parse(page.photo_date)
      if date < (Time.now - 65*24*3600).to_date
        page.following_button.click
        puts "#{user} unfollowed"
        $unfollowed << user
        return
      end
      return if page.like_score > 13
      return if page.liked?
      page.like
      puts "Liked #{user}!!!!!!!!!!!!!!!!!!!!! Woohoo!"
      @count+=1
      sleep 3
    end
  end

  def view_photo(id)
    begin
      Timeout::timeout(5) do
        @browser.goto "https://instagram.com/p/#{id}"
      end
    rescue Timeout::Error => msg
      puts "Recovered from Timeout"
    end
  end

  def view_user(name)
    begin
      Timeout::timeout(5) do
        @browser.goto "https://instagram.com/#{name}/"
      end
    rescue Timeout::Error => msg
      puts "Recovered from Timeout"
    end
    begin
      Timeout::timeout(5) do
        on(InstagramProfile).stats_span.when_present.click
      end
    rescue Timeout::Error => msg
      @browser.refresh
      puts "Recovered from Timeout"
    end
  end

  def get_photo_info
    on InstagramTagPage do |page|
      @current_photo = {
          id: page.most_recent_photo_id,
          last_photo_id: page.last_photo_id
      }
    end
    view_photo @current_photo[:id]
    on InstagramPhotoDetail do |page|
      @current_photo[:user] = page.user_name
      @current_photo[:likes] = page.like_score
      @current_photo[:liked] = page.liked?
    end
    view_user @current_photo[:user]
    on InstagramProfile do |page|
      @current_photo[:followings] = page.following
      @current_photo[:followers] = page.followers
    end
  end

  def log_in
    @browser.link(text: 'Log in').click
    on NonClassicLogin do |page|
      page.username.when_present.set ENV['USER']
      page.password.set ENV['PASS']
      page.log_in
    end
  end

end