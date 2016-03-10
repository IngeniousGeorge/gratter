require_relative "../lib/gratter_class.rb"


describe "gratter" do

  let(:url) { "http://www.livefootball.com/football/england/premier-league/league-table/" }
  let(:xpaths) { { :team => "//td[@class='ltn']/text()", :points => "//td[@class='ltp']/text()" } }
  let(:instance) { Gratter.new( { :url => url, :xpaths => xpaths } ) }
  let(:results) { {:team=>["Team Name", "Leicester City", "Tottenham Hotspur", "Arsenal", "Manchester City", "West Ham United", "Manchester United", "Liverpool", "Stoke City", "Southampton", "Chelsea", "West Bromwich Albion", "Everton", "Watford", "AFC Bournemouth", "Crystal Palace", "Swansea City", "Sunderland", "Norwich City", "Newcastle United", "Aston Villa"], :points=>["PTS", "60", "55", "52", "50", "49", "47", "44", "43", "41", "40", "39", "38", "37", "35", "33", "33", "25", "24", "24", "16"]} }

  it "has a URL" do
    expect(instance.url).to eq("http://www.livefootball.com/football/england/premier-league/league-table/")
  end

  it "returns the selected nodes from the document as strings in a hash" do
    piece = instance.use
    expect(piece).to eq(results)
  end

end

describe "Single Classes" do

  let(:xpaths) { { :team => "//td[@class='ltn']/text()", :points => "//td[@class='ltp']/text()" } }
  let(:results) { {:team=>["Team Name", "Leicester City", "Tottenham Hotspur", "Arsenal", "Manchester City", "West Ham United", "Manchester United", "Liverpool", "Stoke City", "Southampton", "Chelsea", "West Bromwich Albion", "Everton", "Watford", "AFC Bournemouth", "Crystal Palace", "Swansea City", "Sunderland", "Norwich City", "Newcastle United", "Aston Villa"], :points=>["PTS", "60", "55", "52", "50", "49", "47", "44", "43", "41", "40", "39", "38", "37", "35", "33", "33", "25", "24", "24", "16"]} }
  let(:parser) { Parser.new("http://www.livefootball.com/football/england/premier-league/league-table/") }
  let(:xpather) { Xpather.new(Parser.new("http://www.livefootball.com/football/england/premier-league/league-table/").parse, xpaths) }


  describe "Parser" do
    it "returns a Nokogiri document" do
      expect(parser.parse.class).to eql Nokogiri::HTML::Document
    end
  end

  describe "Xpather" do

    it "has a doc to work with" do
      expect(xpather.doc.class).to eql Nokogiri::HTML::Document
    end

    it "returns a hash with the tags and the selected data" do
      expect(xpather.get_data).to eq(results)
    end
  end

end
