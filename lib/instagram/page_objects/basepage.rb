class BasePage < PageFactory

  value(:noko) { |b| WatirNokogiri::Document.new(b.html) }

end