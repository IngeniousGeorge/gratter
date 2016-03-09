require_relative 'scrapy_class'

lequipe = Scrapy.new "http://www.lequipe.fr"

page = lequipe.simple_parse

puts lequipe

puts page
