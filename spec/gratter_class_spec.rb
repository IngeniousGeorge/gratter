require_relative "../lib/gratter_class.rb"


describe "gratter" do

  let(:url) { "http://www.livefootball.com/football/england/premier-league/league-table/" }
  let(:xpaths) { { :team => "//td[@class='ltn']/text()", :points => "//td[@class='ltp']/text()" } }
  let(:inst) { Gratter.new( { :url => url, :xpaths => xpaths } ) }

  it "has a URL" do
    expect(inst.url).to eq("http://www.livefootball.com/football/england/premier-league/league-table/")
  end

  it "returns a piece of a document" do
    piece = inst.use
    expect(piece).to eq("")
  end

end

describe "Single Classes" do

#  let(:doc) { }

# it "returns a Nokogiri document" do
#   doc = inst.use
#   expect(doc.class).to eql Nokogiri::HTML::Document
# end

  describe "Xpather" do

    it "returns a hash with the tags and the selected data" do
      
    end

  end

end
