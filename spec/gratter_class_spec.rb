require_relative "../lib/gratter_class.rb"


describe "gratter" do

  let(:url) { "http://www.livefootball.com/football/england/premier-league/league-table/" }
  let(:xpaths) { { :team => "//td[@class='ltn']/text()", :points => "//td[@class='ltp']/text()" } }
  let(:instance) { Gratter.new( { :url => url, :xpaths => xpaths } ) }

  it "has a URL" do
    expect(instance.url).to eq("http://www.livefootball.com/football/england/premier-league/league-table/")
  end

  it "returns a piece of a document" do
    piece = instance.use
    expect(piece).to eq("")
  end

end

describe "Single Classes" do

  let(:xpaths) { { :team => "//td[@class='ltn']/text()", :points => "//td[@class='ltp']/text()" } }
  let(:results) { { :team => "Team Name", :points => "PTS" } }
  let(:doc) { @doc = parser.parse }

  before(:all) do
    parser = Parser.new("http://www.livefootball.com/football/england/premier-league/league-table/")
    xpather = Xpather.new(@doc, xpaths)
  end

  describe "Parser" do
    it "returns a Nokogiri document" do
      expect(@doc.class).to eql Nokogiri::HTML::Document
    end
  end

  describe "Xpather" do

    it "has a doc to work with" do
      expect(xpather.doc.class).to eql Nokogiri::HTML::Document
    end

    it "returns a hash with the tags and the selected data" do
      expect(xpather.xpath).to eq(results)
    end
  end

end
