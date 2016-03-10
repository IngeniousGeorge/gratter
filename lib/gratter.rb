require_relative 'gratter_class'

lequipe = Gratter.new("http://www.livefootball.com", "//a[@class='btn btnHome']/@href")

puts lequipe.use
