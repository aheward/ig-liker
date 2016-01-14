class Websta < DataFactory

  include Share

  attr_accessor :count, :followers

  def initialize(browser, opts={})
    @browser = browser
    @last_photo = {}
    @followers = {}
    @count = 0
    Instagram::TAGS.each { |t| @last_photo.store(t.to_sym, nil) }
  end

  def script(tag)
    begin
      view(tag)
      same_as_before = @last_photo[tag.to_sym] == on(WebstaPhotoList).photo_id
      DEBUG.message 'Already dealt with photo' if same_as_before
      return if same_as_before
      get_photo_info
      like
      @last_photo[tag.to_sym] = @current_photo[:id]
    rescue Exception => e
      puts 'Websta'
      puts e.message
      e.backtrace.each { |line| puts line }
      sleep 20
    end
    $switch = true if @count > $count_limit
  end

  def view(tag)
    begin
      Timeout::timeout(5) do
        @browser.goto "http://websta.me/tag/#{tag}"
      end
    rescue Timeout::Error => msg
      @browser.execute_script('window.stop();')
      puts "Recovered from Timeout"
    end
    on WebstaLogin do |page|
        if page.log_in_link.present?
          begin
            Timeout::timeout(5) { page.log_in }
          rescue Timeout::Error => msg
            @browser.execute_script('window.stop();')
          end
        end
    end
  end

  def get_photo_info
    on WebstaPhotoList do |page|
      @current_photo = {
          last_user: page.last_user_name,
          user: page.user_name,
          liked: page.liked?,
          id: page.photo_id,
          likes: page.like_count(page.photo_id)
      }
      page.view_user(page.user_name)
    end
    @current_photo[:followings]=on(WebstaUserDetail).following
  end

  def like
    if likable?
      on(WebstaUserDetail).like(@current_photo[:id])
      @count += 1
      puts "#{@count} photos liked"
      sleep rand(5)+2
    end
  end

  def get_followers
    visit WebstaFollowers do |page|
      until page.followers.size >= (page.followers_count-8)
        begin
          page.next_page_button.when_present.click unless page.followers.size >= (page.followers_count-8)
        rescue
          DEBUG.inspect page.followers.size
        end
      end
      page.followers.each { |name| @followers[name] = true }
    end
  end

end