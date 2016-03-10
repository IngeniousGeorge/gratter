require 'nokogiri'
require 'net/http'

class Gratter
  def initialize url
    @url = url
  end

  def url
    @url
  end

  def use
    parser = Parser.new @url
    parser.parse
  end

end

class Parser

  def initialize url
    @url = url
  end

  def parse
    uri  = URI(@url)
    body = Net::HTTP.get(uri)
    document = Nokogiri::HTML(body)
    return document
  end

end
