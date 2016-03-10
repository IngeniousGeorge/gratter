require 'nokogiri'
require 'net/http'

class Gratter

  attr_reader :url
  def initialize(args)
    @url    = args[:url]
    @xpath  = args[:xpath] || {}
  end

  def use
    parser = Parser.new @url
    doc = parser.parse
    xpather = Xpather.new(doc, @xpath)
    result = xpather.xpath
    return result
  end

  # def do
  #   "nothing"
  # end

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

  attr_reader :doc, :xpath
  def initialize(doc, xpath)
    @doc   = doc
    @xpath = xpath
  end

  def get_data
    result = {}
    xpath.each do |tag, xp|
      array = @doc.xpath(xp).to_a
      array.map! { |node| node.to_s }
      result[tag] = array
    end
    return result
  end

end
