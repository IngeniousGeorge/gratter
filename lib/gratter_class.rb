require 'nokogiri'
require 'net/http'

class Gratter

  attr_reader :url

  def initialize(url, xpath)
    @url, @xpath = url, xpath
  end

  def use
    parser = Parser.new @url
    doc = parser.parse
    xpather = Xpather.new(doc, @xpath)
    result = xpather.xpath
  end

  def do
    "nothing"
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
    @doc, @xpath = doc, xpath
  end

  def xpath
    @doc.xpath(@xpath).text
  end

end
