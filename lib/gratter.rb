require_relative 'gratter_class'

url = "http://www.livefootball.com/football/england/premier-league/league-table/"
xpaths = { :team => "(//td[@class='ltn'])[position()>1]/text()", :points => "(//td[@class='ltp'])[position()>1]/text()", :league => "//div[@class='header']/h2/text()" }

livefootball = Gratter.new( { url: url, xpaths: xpaths } )

#puts livefootball.use


parser = Parser.new("http://www.livefootball.com/football/england/premier-league/league-table/")
doc = parser.parse

xpather = Xpather.new(doc, xpaths)
#xpather_doc = xpather.doc
#puts xpather_doc

#xp = xpather.xpath
# puts "xpath:"
# puts xp

results = xpather.get_data
# puts "results:"
#puts results



matcher = Matcher.new(results)
