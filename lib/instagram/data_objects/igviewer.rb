class IGViewer < DataFactory

  attr_accessor :count

  include Share

  def initialize(browser, opts={})
    @browser = browser
    @last_photo = {}
    @followers = {}
    @count = 0
    Instagram::TAGS.each { |t| @last_photo.store(t.to_sym, nil) }
  end

  def script(tag)
    return if tag =~ /[şл]/
    view(tag)
    same_as_before = @last_photo[tag.to_sym] == on(IGViewerTagList).photo_id
    puts 'Already dealt with photo' if same_as_before
    return if same_as_before
    get_photo_info
    like
    @last_photo[tag.to_sym] = @current_photo[:id]
    $switch = true if @count > 25
  end

  def view(tag)
    begin
      Timeout::timeout(5) do
        @browser.goto "http://igs.me/tag/#{tag}"
      end
    rescue Timeout::Error => msg
      puts "Recovered from Timeout"
      @browser.div(class: 'container').click
    end
    on IGViewerTagList do |page|
      page.log_in unless page.logged_in?
    end
  end

  def get_photo_info
    on IGViewerTagList do |page|
      @current_photo = {
          id: page.photo_id,
          user: page.user_name,
          last_user: page.last_user_name,
          likes: page.like_count,
          liked: page.liked?,
      }
      page.view_user
    end
    @current_photo[:followings] = on(IGViewerUser).following(@current_photo[:user])


    DEBUG.inspect @current_photo


  end

  def like
    if likable?
      on IGViewerUser do |page|
        page.like(@current_photo[:user], @current_photo[:id])
        @count += 1
        puts "#{@count} photos liked"
        puts 'A short slumber...'
        sleep rand(35)+2
      end
    end
  end



end