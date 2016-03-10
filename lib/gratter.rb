require_relative 'gratter_class'

url = "http://www.livefootball.com/football/england/premier-league/league-table/"
xpaths = { :team => "//td[@class='ltn']/text()", :points => "//td[@class='ltp']/text()" }

livefootball = Gratter.new( { url: url, xpaths: xpaths } )

#puts livefootball.use

parser = Parser.new("http://www.livefootball.com/football/england/premier-league/league-table/")
doc = parser.parse

xpather = Xpather.new(doc, xpaths)
xpather_doc = xpather.doc
puts xpather_doc

xp = xpather.xpath
puts "xpath:"
puts xp

results = xpather.xpath
puts "results:"
puts results
