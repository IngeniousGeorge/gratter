require_relative 'gratter_class'

# url = "http://www.livefootball.com/football/england/premier-league/league-table/"
# xpaths = { :team => "(//td[@class='ltn'])[position()>1]/text()", :points => "(//td[@class='ltp'])[position()>1]/text()", :league => "//div[@class='header']/h2/text()" }
url = "http://www.livescore.com/soccer/england/premier-league/"
xpaths = { :team => "//div[@class='team']/text()", :points => "//div[@class='pts tot']/text()" }


#football = Gratter.new( { url: url, xpaths: xpaths } )

#puts football.use


parser = Parser.new(url)

doc = parser.parse

xpather = Xpather.new(doc, xpaths)

results = xpather.get_data

puts results

matcher = Matcher.new(results)

matched = matcher.match

puts matched
