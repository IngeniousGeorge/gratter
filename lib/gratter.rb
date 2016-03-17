require_relative 'gratter_class'

url = "http://www.livefootball.com/football/england/premier-league/league-table/"
xpaths = { :team => "(//td[@class='ltn'])[position()>1]/text()", :points => "(//td[@class='ltp'])[position()>1]/text()", :league => "//div[@class='header']/h2/text()" }
trans_pattern = { :league => Proc.new { |node| node.gsub /.*&#8211; /, '' } }
# url = "http://www.livescore.com/soccer/england/premier-league/"
# xpaths = { :team => "//div[@class='team']/text()", :points => "//div[@class='pts tot']/text()", :league => "//div[@class='left']//a//text()" }
# url = "http://pitchfork.com/reviews/albums/21631-no-one-deserves-happiness/"
# xpaths = { :album => "//h1[@class='review-title']/text()", :artist => "//h2[@class='artists']//a/text()", :rating => "//span[@class='score']/text()" }

football = Gratter.new( { url: url, xpaths: xpaths, trans_pattern: trans_pattern } )

puts football.use

s = "England &#8211; Premier League"
s.slice! "England &#8211; "
p s

# parser = Parser.new(url)
#
# doc = parser.parse
#
# xpather = Xpather.new(doc, xpaths)
#
# results = xpather.get_data
#
# #puts results
#
# matcher = Matcher.new(results)
#
# result = matcher.match
#
# puts result
