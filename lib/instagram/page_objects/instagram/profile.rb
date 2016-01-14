class InstagramProfile < PageFactory

  value(:following) { |b| b.stats_span.li(index: 2).span.span(index: 1).text.groom.to_i }
  value(:followers) { |b| b.stats_span.li(index: 1).span.span(index: 1).title.groom.to_i }

  element(:stats_span) { |b| b.ul }

end