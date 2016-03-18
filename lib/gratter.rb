require_relative 'gratter_class'
require 'date'


# Livefootball
url = "http://www.livefootball.com/football/england/premier-league/league-table/"
xpaths = { :team => "(//td[@class='ltn'])[position()>1]/text()", :points => "(//td[@class='ltp'])[position()>1]/text()", :league => "//div[@class='header']/h2/text()" }
to_be_added = { :date => "" }
trans_pattern = { :league => Proc.new { |node| node.gsub /.*&#8211; /, '' }, :date => Proc.new { |node| (Date.today << 1).to_s } }

# Livescore
# url = "http://www.livescore.com/soccer/england/premier-league/"
# xpaths = { :team => "//div[@class='team']/text()", :points => "//div[@class='pts tot']/text()", :league => "//div[@class='left']//a//text()" }

# Pitchfork
# url = "http://pitchfork.com/reviews/albums/21631-no-one-deserves-happiness/"
# xpaths = { :album => "//h1[@class='review-title']/text()", :artist => "//h2[@class='artists']//a/text()", :rating => "//span[@class='score']/text()" }


result = Gratter.new( { url: url, xpaths: xpaths, to_be_added: to_be_added, trans_pattern: trans_pattern } )

#puts result.use

#con = Mysql.new('localhost', 'root', 'tely')

#puts con.get_server_info
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
