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

  ## input -> url
  ## output -> Nokogiri::HTML::Document

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

  ## input -> Nokogiri::HTML::Document
  ## output -> { :key => ['values'] }

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

class Adder

  ## input -> { :key => ['values'] } (xpather_output) / { :key => "to add" }
  ## output -> { :key => ['values'] }

  attr_reader :data, :to_be_added

  def initialize data, to_be_added
    @data = data
    @to_be_added = to_be_added
  end

  def add_tags
    format_to_be_added
    to_be_added.merge(data)
  end

    def format_to_be_added
      to_be_added.each do |tag,value|
        to_be_added[tag] = [value] unless value.class == Array
      end
    end

end

class Matcher

  ## input -> { :key => ['values', values], :key => ['values'] }
  ## output -> [ { :key => ['value'], :key => ['value'] }, { :key => ['value'], :key => ['value'] } ]

  attr_accessor :data
  def initialize data
    @data = data
  end

  def match
    sizes = get_arrays_sizes
    check_for_uniform_arrays(sizes)
    make_arrays_uniform(sizes) if sizes.max != sizes.min
    match_nodes(sizes.max)
  end

    def get_arrays_sizes
      sizes = []
      data.each { |tag,value| sizes << value.size }
      return sizes #puts sizes #=> {:album=>1, :artist=>1, :rating=>1} / {:team=>21, :points=>21, :league=>1}
    end

    def check_for_uniform_arrays sizes
      uniques = sizes.uniq # p uniques => [1] / [21, 1]
      uniques.delete(1) if uniques.include?(1) && uniques.size > 1
      raise ArgumentError if uniques.size > 1 # "Invalid data: Node lists are not of the same size and cannot be matched"
    end

    def make_arrays_uniform sizes
      max = sizes.max
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
