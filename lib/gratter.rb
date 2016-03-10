require_relative 'gratter_class'

url = "http://www.livefootball.com/football/england/premier-league/league-table/"
xpaths = { :team => "//td[@class='ltn']/text()", :points => "//td[@class='ltp']/text()" }

livefootball = Gratter.new( { url: url, xpaths: xpaths } )

puts livefootball.use
