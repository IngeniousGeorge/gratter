require_relative "../lib/gratter_class.rb"


describe "gratter" do

  let(:url) { "http://www.livefootball.com/football/england/premier-league/league-table/" }
  let(:xpaths) { { :team => "(//td[@class='ltn'])[position()>1]/text()", :points => "(//td[@class='ltp'])[position()>1]/text()" } }
  let(:expected_max_num_of_nodes) { 20 }
  let(:instance) { Gratter.new( { :url => url, :xpaths => xpaths } ) }
  let(:data) { instance.use }

  it "has a URL" do
    expect(instance.url).to match(/http:\/\/.*/)
  end

  it "has tags and xpaths" do
    expect(instance.xpaths).to be_kind_of(Hash)
  end

  it "returns an array" do
    expect(data.class).to be(Array)
  end

  it "returns an array of size equal to the max number of nodes" do
    expect(data.size).to eql(expected_max_num_of_nodes)
  end

  describe "Single Classes" do

    describe "Parser" do

      let(:parser) { Parser.new("http://www.duckduckgo.com") }

      it "returns a Nokogiri document on parse" do
        expect(parser.parse.class).to eql(Nokogiri::HTML::Document)
      end

    end

    describe "Xpather" do

      let(:xpaths) { { :tag1 => "//div", :tag2 => "//span" } }
      let(:xpather) { Xpather.new(Parser.new("http://www.duckduckgo.com").parse, xpaths) }
      let(:data) { xpather.get_data }

      it "has a Nokogiri document to work with" do
        expect(xpather.doc.class).to eql(Nokogiri::HTML::Document)
      end

      it "returns a hash of the same size as the xpaths" do
        expect(data.class).to eql(Hash)
        expect(data.size).to eql(xpaths.size)
      end

    end

    describe "Matcher" do

      #multi nodes results

      let(:xpather_output) { {:team=>["Leicester City", "Tottenham Hotspur", "Arsenal", "Manchester City", "West Ham United", "Manchester United", "Southampton", "Liverpool", "Stoke City", "Chelsea", "West Bromwich Albion", "Everton", "AFC Bournemouth", "Watford", "Crystal Palace", "Swansea City", "Sunderland", "Norwich City", "Newcastle United", "Aston Villa"], :points=>["63", "58", "52", "51", "49", "47", "44", "44", "43", "40", "39", "38", "38", "37", "33", "33", "25", "25", "24", "16"]} }
      let(:matcher) { Matcher.new(xpather_output) }
      let(:matcher_result) { [ {:team=>"Leicester City", :points=>"63"}, {:team=>"Tottenham Hotspur", :points=>"58"}, {:team=>"Arsenal", :points=>"52"}, {:team=>"Manchester City", :points=>"51"}, {:team=>"West Ham United", :points=>"49"}, {:team=>"Manchester United", :points=>"47"}, {:team=>"Southampton", :points=>"44"}, {:team=>"Liverpool", :points=>"44"}, {:team=>"Stoke City", :points=>"43"}, {:team=>"Chelsea", :points=>"40"}, {:team=>"West Bromwich Albion", :points=>"39"}, {:team=>"Everton", :points=>"38"}, {:team=>"AFC Bournemouth", :points=>"38"}, {:team=>"Watford", :points=>"37"}, {:team=>"Crystal Palace", :points=>"33"}, {:team=>"Swansea City", :points=>"33"}, {:team=>"Sunderland", :points=>"25"}, {:team=>"Norwich City", :points=>"25"}, {:team=>"Newcastle United", :points=>"24"}, {:team=>"Aston Villa", :points=>"16"} ] }
      #single node vars
      let(:xpaths_single_node) { { :team => "(//td[@class='ltn'])[1]/text()", :points => "(//td[@class='ltp'])[1]/text()" } }
      let(:xpather_output_single_node) { {:team=>["Leicester City"], :points=>["63"]} }
      let(:matcher_single_node) { Matcher.new(xpather_output_single_node) }
      let(:matcher_result_single_node) { [ { :team=>"Leicester City", :points=>"63" } ] }
      #mixed results vars
      let(:xpaths_mixed) { { :team => "(//td[@class='ltn'])[position()>1]/text()", :points => "(//td[@class='ltp'])[position()>1]/text()", :league => "//div[@class='header']/h2/text()" } }
      let(:xpather_mixed_output) { {:team=>["Leicester City", "Tottenham Hotspur", "Arsenal", "Manchester City", "West Ham United", "Manchester United", "Southampton", "Liverpool", "Stoke City", "Chelsea", "West Bromwich Albion", "Everton", "AFC Bournemouth", "Watford", "Crystal Palace", "Swansea City", "Sunderland", "Norwich City", "Newcastle United", "Aston Villa"], :points=>["63", "58", "52", "51", "49", "47", "44", "44", "43", "40", "39", "38", "38", "37", "33", "33", "25", "25", "24", "16"], :league=>"England - Premier League"} }
      let(:matcher_mixed) { Matcher.new(xpather_mixed_output) }
      let(:matcher_mixed_result) { [ {:team=>"Leicester City", :points=>"63", :league=>"England - Premier League"}, {:team=>"Tottenham Hotspur", :points=>"58", :league=>"England - Premier League"}, {:team=>"Arsenal", :points=>"52", :league=>"England - Premier League"}, {:team=>"Manchester City", :points=>"51", :league=>"England - Premier League"}, {:team=>"West Ham United", :points=>"49", :league=>"England - Premier League"}, {:team=>"Manchester United", :points=>"47", :league=>"England - Premier League"}, {:team=>"Southampton", :points=>"44", :league=>"England - Premier League"}, {:team=>"Liverpool", :points=>"44", :league=>"England - Premier League"}, {:team=>"Stoke City", :points=>"43", :league=>"England - Premier League"}, {:team=>"Chelsea", :points=>"40", :league=>"England - Premier League"}, {:team=>"West Bromwich Albion", :points=>"39", :league=>"England - Premier League"}, {:team=>"Everton", :points=>"38", :league=>"England - Premier League"}, {:team=>"AFC Bournemouth", :points=>"38", :league=>"England - Premier League"}, {:team=>"Watford", :points=>"37", :league=>"England - Premier League"}, {:team=>"Crystal Palace", :points=>"33", :league=>"England - Premier League"}, {:team=>"Swansea City", :points=>"33", :league=>"England - Premier League"}, {:team=>"Sunderland", :points=>"25", :league=>"England - Premier League"}, {:team=>"Norwich City", :points=>"25", :league=>"England - Premier League"}, {:team=>"Newcastle United", :points=>"24", :league=>"England - Premier League"}, {:team=>"Aston Villa", :points=>"16", :league=>"England - Premier League"} ] }


      it "has an array to work with" do
        expect(matcher.data).to eq(xpather_output)
      end

      it "returns an array of size 1 with inside a hash of symbol => strings instead of an hash of symbol => array if all tags returned just one node" do
        # pending 'input = { :tagA => ["valA"], :tagB => ["valB"] }
        #   output = { :tagA => "valA", :tagB => "valB" }'
        expect(matcher_single_node.match).to eq(matcher_result_single_node)
      end

      it "returns an array(size=num_of_nodes) of hashes(tag => value pairs) instead of an hash of arrays" do
        # pending 'input: { :tagA => ["val1A", "val2A"], :tagB => ["val1B", "val2B"] }
        #   output = [ [1] => { :tagA => "val1A", :tagB => "val1B" },
        #              [2] => { :tagA => "val2A", :tagB => "val2B" }'
        expect(matcher.match_many_nodes).to eq(matcher_result)
      end

      it "returns an array of hashes, with tags returning a single value being duplicated in all hashes" do
        # pending 'input: { :tagA => ["val1A", "val2A"], :tagB => "val1B" }
        #   output = [ {:tagA => "val1A"}, {:tagA => "val2A"}, {:tagB => "val1B"}, {:tagB => "val1B"}, ]'
        expect(matcher_mixed.match).to eq(matcher_mixed_result)
      end

    end

    describe "Adder" do

      it "adds specific data to the scraping result array" do
        pending 'input = { :tagA => "valA", :tagB => ["val1B", "val2B"] } -- takes strings and put them in all, takes arrays and distributes them'
      end

    end

  end

end
