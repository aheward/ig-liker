class Collecto < DataFactory

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
      same_as_before = @last_photo[tag.to_sym] == on(CollectoTagView).photo_id
      DEBUG.message 'Already dealt with photo' if same_as_before
      return if same_as_before
      get_photo_info
      like
      @last_photo[tag.to_sym] = @current_photo[:id]
    rescue Exception => e
      @browser.execute_script('window.stop();')
      puts 'Collecto'
      puts e.message
      e.backtrace.each { |line| puts line }
      sleep 20
    end
    $switch = true if @count > $count_limit
  end

  def view(tag)
    if @count == 0
      visit CollectoBase do |page|
        page.sign_in unless page.nav_profile.present?
        page.div(id: 'loading').wait_while_present
      end
      @browser.goto "http://collec.to/tag/#{tag}"
    else
      @browser.goto "http://collec.to/tag/#{tag}"
    end
    @browser.div(id: 'loading').wait_while_present
    on(CollectoTagView).sidebar.wait_until_present
  end

  def get_photo_info
    on CollectoTagView do |page|
      @current_photo = {
          last_user: page.last_user_name,
          user: page.user_name,
          liked: page.liked?,
          id: page.photo_id,
          likes: page.like_count
      }
      page.view_poster
      @current_photo[:followings] = page.followings
      page.close_modal
    end
  end

  def like
    if likable?
      on(CollectoTagView).like(@current_photo[:id])
      @count += 1
      puts "#{@count} photos liked"
      puts 'zzzzzzzz...'
      sleep rand(20)+2
    end
  end

end