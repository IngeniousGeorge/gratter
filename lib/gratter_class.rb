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
    arrays_sizes = get_arrays_sizes
    check_data(arrays_sizes)
    reorder_data(arrays_sizes) if arrays_sizes.max[1] != arrays_sizes.min[1]
    match_nodes(arrays_sizes.max)
  end

  def get_arrays_sizes
    sizes = {}
    data.each { |tag,value| sizes[tag] = value.size }
    puts sizes
    return sizes #puts sizes #=> {:album=>1, :artist=>1, :rating=>1} / {:team=>21, :points=>21, :league=>1}
  end

  def check_data sizes
    uniques = sizes.values.uniq # p uniques => [1] / [21, 1]
    uniques.delete(1) if uniques.include?(1) && uniques.size > 1
    raise "problem" if uniques.size > 1
  end

  def reorder_data sizes
    puts "here"
    max = sizes.max[1]
    puts max
    data.each do |tag,value|
      if value.size == 1 then
        puts "found"
        array = []
        array = max.times { array << value }
        puts array
        data[tag] = array
      end
    end
  end

  def match_nodes size
    result = Array.new(size) { {} }
    data.each do |tag, array|
      array.each_with_index do |value,index|
        result[index][tag] = value
      end
    end
    return result
  end

end

  # def arrays_differ_in_size?
  #   sizes = []
  #   data.each do |tag,value|
  #     sizes << value.size unless value.class != Array
  #   end
  #   return false if sizes.empty?
  #   sizes.uniq.size != 1
  # end
  #
  # def single_nodes_only?
  #   single_nodes = 0
  #   data.each do |tag,value|
  #     single_nodes += 1 if value.class == String
  #   end
  #   single_nodes == data.size
  # end
  #
  # def strings_mixed_with_arrays?
  #   single_nodes = 0
  #   arrays = 0
  #   data.each do |tag,value|
  #     single_nodes += 1 if value.class == String
  #     arrays += 1 if value.class == Array
  #   end
  #   single_nodes > 0 && arrays > 0
  # end
  #
  # # def reorder_data
  # #   data.each do |tag,value|
  # #     if value.class == String then
  # #       data[tag] = Array.new(3) { value.to_s }
  # #     end
  # #   end
  # #   return data
  # # end
  #
  # def get_max_num_of_nodes
  #   sizes = []
  #   data.each do |tag,value|
  #     sizes << value.size unless value.class != Array
  #   end
  #   sizes.max
  # end
  #
  # def get_min_num_of_nodes
  #   sizes = []
  #   data.each do |tag,value|
  #     sizes << value.size unless value.class != Array
  #   end
  #   sizes.max
  # end
  #
  # def all_arrays_same_size?
  #   sizes = []
  #   data.each do |tag,value|
  #     sizes << value.size unless value.class != Array
  #   end
  #   sizes.uniq.size == 1
  # end
  #
  # def create_full_arrays_for_single_nodes
  #   data.each do |tag,value|
  #     if value.class == String then
  #       #data[tag] = Array.new(@max_num_of_nodes) { value.to_s }
  #     end
  #   end
  #   return data
  # end
  #
  #
  # def match_single_nodes
  #   data.each do |tag, val|
  #     data[tag] = val.to_s
  #   end
  #   return [data]
  # end



# raise "Invalid data: Node lists are not of the same size and cannot be matched" if arrays_differ_in_size?
# return match_single_nodes if single_nodes_only?
# @data = reorder_data if strings_mixed_with_arrays?
# return match_many_nodes
