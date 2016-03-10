require 'nokogiri'
require 'net/http'

class Gratter

  attr_reader :url
  attr_reader :xpath

  def initialize(url, xpath)
    @url = url
    @xpath = xpath
  end

  def parse
    parser = Parser.new @url
    parser.parse
  end

  def xpath
    parser = Parser.new @url
    doc = parser.parse
    xpather = Xpather.new @xpath
    xpather.xpath(doc xpath)
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

class Xpather

  def initialize(doc, xpath)
    @doc = doc
    @xpath = xpath
  end

  def xpath
    "/"
  end

end
