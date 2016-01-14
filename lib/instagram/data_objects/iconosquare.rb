# coding: UTF-8
class Iconosquare < DataFactory

  attr_accessor :followers, :count, :followings

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
      if on(IconosquareBase).get_yours_button.present?
        $switch = true
        return
      end
      same_as_before = @last_photo[tag.to_sym] == on(IconosquarePhotos).photo_ids[0]
      puts 'Already dealt with photo' if same_as_before
      return if same_as_before
      get_photo_info
      like
      @last_photo[tag.to_sym] = @current_photo[:id]
    rescue Exception => e
      puts 'Iconosquare'
      puts e.message
      e.backtrace.each { |line| puts line }
      sleep 10
    end
    $switch = true if @count > $count_limit
  end

  def view(tag)
    begin
      Timeout::timeout(10) do
        @browser.goto "http://iconosquare.com/viewer.php#/tag/#{tag}/grid"
      end
    rescue Timeout::Error => msg
      @browser.execute_script('window.stop();')
      puts "Recovered from Timeout"
    end
  end

  def get_photo_info
    on IconosquarePhotos do |page|
      id0 = page.photo_ids[0]
      id1 = page.photo_ids[1]
      @current_photo = {
          user_name: page.user_name(id0),
          user_id: user_id(id0),
          last_user_id: user_id(id1),
          id: id0,
          liked: page.liked?(id0),
          likes: page.like_score(id0)
      }
      page.view_user
    end
    on IconosquareUser do |page|
      @current_photo[:followings] = page.followings
    end
  end

  def likable?
    cp = @current_photo
    puking_photos = cp[:user_id] == cp[:last_user_id]
    already_liked = cp[:liked]
    spammer = cp[:followings]<5
    follower = $followers[cp[:user_name].to_sym]
    too_many_likes = cp[:likes]>10

    puts 'User posting multiple photos' if puking_photos
    puts 'Photo already liked' if already_liked
    puts 'Spammer' if spammer
    puts 'A follower' if follower
    puts 'Photo has too many likes' if too_many_likes

    return false if puking_photos || already_liked || spammer
    return false if follower && !too_many_likes
    return false if too_many_likes && !follower
    true
  end

  def like
    if likable?
      id = @current_photo[:id]
      on IconosquareUser do |page|
        likes = page.like_score id
        page.like id
        sleep 2
        if likes == page.like_score(id)
          $switch = true
          puts 'Like was rejected!'
        else
          @count += 1
          puts "#{@count} photos liked"
          puts 'a little nap...'
          sleep rand(35)
        end
      end
    end
  end

  def get_followers
    visit IconosquareFollowers do |page|
      sleep 15
      page.user_buttons.wait_until_present               #DEBUG
      until page.followers.size >= (page.followers_count-8)
        begin
          page.more unless page.followers.size >= (page.followers_count-8)
          sleep 2
        rescue Watir::Exception::UnknownObjectException, Watir::Wait::TimeoutError
          DEBUG.inspect page.followers.size
          DEBUG.inspect page.followers_count
        end
      end
    end
    on(IconosquareFollowers).followers.each { |id| @followers[id] = true }
    puts 'Followers count:'
    puts @followers.count
  end

  def get_followings
    @browser.goto 'http://iconosquare.com/viewer.php#/myFollowings/'
    on IconosquareFollowers do |page|
      page.user_buttons.wait_until_present
      until page.followings.size >= (page.followings_count-8)
        while page.try_again_button.present?
          page.try_again
          sleep 5
        end
        begin
          page.more unless page.followings.size >= (page.followings_count-8)
        rescue Watir::Exception::UnknownObjectException, Watir::Wait::TimeoutError
          DEBUG.inspect page.followings.size
          DEBUG.inspect page.followings_count
        end
      end
      @followings = page.followings
    end
  end

  def user_id(photo_id)
    photo_id[/\d+$/].to_sym
  end

end