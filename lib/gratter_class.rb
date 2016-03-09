require 'nokogiri'
require 'net/http'

class Gratter
  def initialize url
    @url = url
  end

  def url
    @url
  end

  def simple_parse
    uri  = URI(@url)
    body = Net::HTTP.get(uri)
    document = Nokogiri::HTML(body)
    return document
  end

end
