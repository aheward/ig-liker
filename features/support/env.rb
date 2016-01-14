require "#{File.dirname(__FILE__)}/../../lib/instagram"

World Foundry

Before do
  # Get the browser object
  instagram = Instagram.new :ff
  @browser = instagram.browser
end