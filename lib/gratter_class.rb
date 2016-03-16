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
    xpather_result = xpather.get_data
    matcher = Matcher.new(xpather_result)
    matcher_result = matcher.match
    return matcher_result
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

  attr_accessor :data
  def initialize data
    @data = data
  end

  def match
    sizes = get_arrays_sizes
    check_for_uniform_arrays(sizes)
    make_arrays_uniform(sizes) if sizes.max[1] != sizes.min[1]
    match_nodes(sizes.max[1])
  end

    def get_arrays_sizes
      sizes = {}
      data.each { |tag,value| sizes[tag] = value.size }
      return sizes #puts sizes #=> {:album=>1, :artist=>1, :rating=>1} / {:team=>21, :points=>21, :league=>1}
    end

    def check_for_uniform_arrays sizes
      uniques = sizes.values.uniq # p uniques => [1] / [21, 1]
      uniques.delete(1) if uniques.include?(1) && uniques.size > 1
      raise "problem" if uniques.size > 1
    end

    def make_arrays_uniform sizes
      max = sizes.max[1]
      data.each do |tag,value|
        if value.size == 1 then
          array = []
          max.times { array << value[0] }
          data[tag] = array
        end
      end
    end

    def match_nodes size
      result = Array.new(size) { {} }
      data.each do |tag, array|
        array.each_with_index do |value,index|
          hash = { tag => value }
          result.at(index).merge!( hash ) # p tag, array, value, index => :album / ["No One Deserves Happiness"] / "No One Deserves Happiness" / 0
        end
      end
      return result
    end

end
