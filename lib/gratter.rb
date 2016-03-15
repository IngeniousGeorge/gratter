require_relative 'gratter_class'

url = "http://www.livefootball.com/football/england/premier-league/league-table/"
xpaths = { :team => "(//td[@class='ltn'])[position()>1]/text()", :points => "(//td[@class='ltp'])[position()>1]/text()", :league => "//div[@class='header']/h2/text()" }

livefootball = Gratter.new( { url: url, xpaths: xpaths } )

#puts livefootball.use


parser = Parser.new("http://www.livefootball.com/football/england/premier-league/league-table/")

doc = parser.parse

xpather = Xpather.new(doc, xpaths)

results = xpather.get_data

matcher = Matcher.new(results)

array = matcher.create_full_arrays_for_single_nodes

puts array
