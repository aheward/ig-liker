class Tofo < DataFactory

  include Share

  attr_accessor :count

  def initialize(browser, opts={})
    @browser = browser
    @last_photo = {}
    @count = 0
    Instagram::TAGS.each { |t| @last_photo.store(t.to_sym, nil) }
  end

  def script(tag)
    begin
      view(tag)
      same_as_before = @last_photo[tag.to_sym] == on(TofoPhotoList).photo_id
      DEBUG.message 'Already dealt with photo' if same_as_before
      return if same_as_before
      get_photo_info
      like
      @last_photo[tag.to_sym] = @current_photo[:id]
    rescue Exception => e
      puts 'Tofo'
      puts e.message
      e.backtrace.each { |line| puts line }
      sleep 20
    end
    $switch = true if @count > $count_limit
  end

  def view(tag)
    begin
      Timeout::timeout(10) { @browser.goto "https://tofo.me/tag/#{tag}" }
    rescue Timeout::Error => msg
      puts "Recovered from Timeout"
    end
    on(TofoPhotoList).sign_in
  end

  def get_photo_info
    on TofoPhotoList do |page|
      @current_photo = {
          last_user: page.prior_poster_name,
          user: page.poster_name,
          liked: page.liked?,
          id: page.photo_id,
          likes: page.like_count
      }
    end
    @browser.goto "https://tofo.me/#{@current_photo[:user]}"
    @current_photo[:followings] = on(TofoUserProfile).following_count
  end

  def like
    if likable?
      on(TofoUserProfile).like(@current_photo[:id])
      @count += 1
      puts "#{@count} photos liked"
      puts 'nap time!'
      sleep rand(30)+2
    end
  end

end