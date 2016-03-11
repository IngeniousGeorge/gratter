require_relative "../lib/gratter_class.rb"


describe "gratter" do

  let(:url) { "http://www.livefootball.com/football/england/premier-league/league-table/" }
  let(:xpaths) { { :team => "(//td[@class='ltn'])[position()>1]/text()", :points => "(//td[@class='ltp'])[position()>1]/text()" } }
  let(:instance) { Gratter.new( { :url => url, :xpaths => xpaths } ) }
  let(:results) { {:team=>["Leicester City", "Tottenham Hotspur", "Arsenal", "Manchester City", "West Ham United", "Manchester United", "Liverpool", "Stoke City", "Southampton", "Chelsea", "West Bromwich Albion", "Everton", "Watford", "AFC Bournemouth", "Crystal Palace", "Swansea City", "Sunderland", "Norwich City", "Newcastle United", "Aston Villa"], :points=>["60", "55", "52", "50", "49", "47", "44", "43", "41", "40", "39", "38", "37", "35", "33", "33", "25", "24", "24", "16"]} }

  it "has a URL" do
    expect(instance.url).to eq("http://www.livefootball.com/football/england/premier-league/league-table/")
  end

  it "has tags and xpaths" do
    expect(instance.xpaths).to eq( { :team => "(//td[@class='ltn'])[position()>1]/text()", :points => "(//td[@class='ltp'])[position()>1]/text()" } )
  end

  it "returns the selected nodes from the document as strings in a hash when use is called" do
    piece = instance.use
    expect(piece).to eq(results)
  end

  describe "Single Classes" do

    let(:parser) { Parser.new("http://www.livefootball.com/football/england/premier-league/league-table/") }
    let(:xpather) { Xpather.new(Parser.new("http://www.livefootball.com/football/england/premier-league/league-table/").parse, xpaths) }

    describe "Parser" do
      it "returns a Nokogiri document on parse" do
        expect(parser.parse.class).to eql Nokogiri::HTML::Document
      end
    end

    describe "Xpather" do

      it "has a Nokogiri document to work with" do
        expect(xpather.doc.class).to eql Nokogiri::HTML::Document
      end

      it "returns a hash with the tags and the selected data on get_data" do
        expect(xpather.get_data).to eq(results)
      end
    end

  end

end
