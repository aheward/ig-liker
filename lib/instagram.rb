# coding: UTF-8
require 'test-factory'
require 'watir-nokogiri'
require 'date'

Dir["#{File.dirname(__FILE__)}/instagram/*.rb"].alphabetize.each {|f| require f }
Dir["#{File.dirname(__FILE__)}/instagram/page_objects/*.rb"].alphabetize.each {|f| require f }
Dir["#{File.dirname(__FILE__)}/instagram/page_objects/*/*.rb"].alphabetize.each {|f| require f }
Dir["#{File.dirname(__FILE__)}/instagram/data_objects/*.rb"].alphabetize.each {|f| require f }

class Instagram

  attr_reader :browser

  def initialize(web_browser)

    @browser = Watir::Browser.new web_browser
    @browser.window.resize_to(1000,1000)

  end

  TAGS = %w{ paragliding yamaçparaşütü параплан параглайдинг
             parapente paraglider paraglide paragliders wonderlust
             scubadiving climbing voolivre instagramaz flight sailplane
             flyozone blackrockcity burningman2015 adrenaline
             skydiving aerobatics aviation solparagliders parapendio
             pointofthemountain torreypinesgliderport shawbutte phoenixmountainpreserve
  }

  $count_limit = 3000

end