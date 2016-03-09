# Scrapy takes params and returns an array of values
######################################################
# Params are -> location of data
#               transformation of data
#               format of returned data
# Location:
#   start URL: the URL where data will be taken from || the URL where we find links to the pages where data will be taken from
#   links_xpaths: the xpath to the links in start URL [they overwrite start_URL after completion]|| nil, if the start URL is the page where the data is found
#   url_trans: the transformation applied to each/the start URL to get more URLs || nil, if no transformation is needed
#   tags_xpaths: a hash of the xpaths to the data with its corresponding tag
#
# Transformation of data:
#   data_trans: a hash with the data tags as keys as code block to apply to the data as values
#
# Format of returned data:
#   table: name of the table destionation
#   tags: a hash of the table's fields as keys and the corresponding tags, one or more, from the scraped data
#       (ex: { "author" => "first_name last_name", "date" => "date"})
######################################################
# Methods are -> new_nested_hash [returns an empty nested hash]
#                parse_url       [takes a URL, returns a Nokogiri document]
#                simple_xpath    [takes a Nokogiri doc, a tag and a xpath, returns a hash to tags as keys and scraped data as values]
#
#
#
#
#
######################################################
# Author @JC_DryTheRain

require_relative "../lib/scrapy_class.rb"


describe "scrapy" do

  let(:url) { "http://www.livefootball.com" }
  let(:inst) { Scrapy.new "http://www.livefootball.com" }

  it "has a URL" do
    raise unless Scrapy.new("http://www.livefootball.com").url == "http://www.livefootball.com"
  end

  it "returns a Nokogiri document" do
    doc = inst.simple_parse
    expect(doc.class).to eql Nokogiri::HTML::Document
  end

end
