require_relative 'gratter_class'

lequipe = Gratter.new "http://www.lequipe.fr"

page = lequipe.simple_parse

puts lequipe

puts page
