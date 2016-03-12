require 'nokogiri'
require 'net/http'

class Gratter

  attr_reader :url
  attr_reader :xpaths
  def initialize(args)
    @url    = args[:url]
    @xpaths  = args[:xpaths] #|| {}
  end

  def use
    parser = Parser.new @url
    doc = parser.parse
    xpather = Xpather.new(doc, @xpaths)
    result = xpather.get_data
    return result
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

  attr_reader :doc, :xpaths
  def initialize(doc, xpaths)
    @doc   = doc
    @xpaths = xpaths
  end

  def get_data
    result = {}
    xpaths.each do |tag, xp|
      array = @doc.xpath(xp).to_a
      array.map! { |node| node.to_s }
      result[tag] = array
    end
    return result
  end

end

class Matcher

  attr_reader :data, :num_of_nodes
  def initialize data
    @data = data
  end

  def get_num_of_nodes
    num_of_nodes = 20
  end

  def create_full_arrays_for_single_nodes

  end

  def match_many_nodes
    num_of_nodes = get_num_of_nodes
    result = []
    result = Array.new(num_of_nodes) { {} }
    data.each do |tag, array|
      array.each_with_index do |value,index|
        result[index][tag] = value
      end
    end
    return result
  end

  def match_single_nodes
    data.each do |tag, val|
      data[tag] = val[0].to_s
    end
    return [data]
  end

end
