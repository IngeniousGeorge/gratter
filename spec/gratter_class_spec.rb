require_relative "../lib/gratter_class.rb"


describe "gratter" do

  let(:url) { "http://www.livefootball.com/football/england/premier-league/league-table/" }
  let(:xpaths) { { :team => "(//td[@class='ltn'])[position()>1]/text()", :points => "(//td[@class='ltp'])[position()>1]/text()" } }
  let(:instance) { Gratter.new( { :url => url, :xpaths => xpaths } ) }
  let(:xpather_output) { {:team=>["Leicester City", "Tottenham Hotspur", "Arsenal", "Manchester City", "West Ham United", "Manchester United", "Liverpool", "Stoke City", "Southampton", "Chelsea", "West Bromwich Albion", "Everton", "Watford", "AFC Bournemouth", "Crystal Palace", "Swansea City", "Sunderland", "Norwich City", "Newcastle United", "Aston Villa"], :points=>["60", "55", "52", "50", "49", "47", "44", "43", "41", "40", "39", "38", "37", "35", "33", "33", "25", "24", "24", "16"]} }

  it "has a URL" do
    expect(instance.url).to eq("http://www.livefootball.com/football/england/premier-league/league-table/")
  end

  it "has tags and xpaths" do
    expect(instance.xpaths).to eq( { :team => "(//td[@class='ltn'])[position()>1]/text()", :points => "(//td[@class='ltp'])[position()>1]/text()" } )
  end

  it "returns the selected nodes from the document as strings in a hash when use is called" do
    piece = instance.use
    expect(piece).to eq(xpather_output)
  end

  describe "Single Classes" do

    describe "Parser" do

      let(:parser) { Parser.new("http://www.livefootball.com/football/england/premier-league/league-table/") }

      it "returns a Nokogiri document on parse" do
        expect(parser.parse.class).to eql Nokogiri::HTML::Document
      end
    end

    describe "Xpather" do

      let(:xpather) { Xpather.new(Parser.new("http://www.livefootball.com/football/england/premier-league/league-table/").parse, xpaths) }

      it "has a Nokogiri document to work with" do
        expect(xpather.doc.class).to eql Nokogiri::HTML::Document
      end

      it "returns a hash with the tags and the selected data on get_data" do
        expect(xpather.get_data).to eq(xpather_output)
      end
    end

    describe "Matcher" do

      let(:xpaths_single_node) { { :team => "(//td[@class='ltn'])[1]/text()", :points => "(//td[@class='ltp'])[1]/text()" } }
      let(:xpather_output_single_node) { {:team=>["Leicester City"], :points=>["60"]} }
      let(:matcher) { Matcher.new(xpather_output) }
      let(:matcher_single_node) { Matcher.new(xpather_output_single_node) }
      let(:matcher_result_single_node) { [ { :team=>"Leicester City", :points=>"60" } ] }
      let(:matcher_result) { [ { :team => "Leicester City", :points => "60" }, { :team => "Tottenham Hotspur", :points => "55" }, { :team => "Arsenal", :points => "52" }, { :team => "Manchester City", :points => "50" }, { :team => "West Ham United", :points => "49" }, { :team => "Manchester United", :points => "47" }, { :team => "Liverpool", :points => "44" }, { :team => "Stoke City", :points => "43" }, { :team => "Southampton", :points => "41" }, { :team => "Chelsea", :points => "40" }, { :team => "West Bromwich Albion", :points => "39" }, { :team => "Everton", :points => "38" }, { :team => "Watford", :points => "37" }, { :team => "AFC Bournemouth", :points => "35" }, { :team => "Crystal Palace", :points => "33" }, { :team => "Swansea City", :points => "33" }, { :team => "Sunderland", :points => "25" }, { :team => "Norwich City", :points => "24" }, { :team => "Newcastle United", :points => "24" }, { :team => "Aston Villa", :points => "16" } ] }

      it "has an array to work with" do
        expect(matcher.data).to eq(xpather_output)
      end

      it "returns an array of size 1 with inside a hash of symbol => strings instead of an hash of symbol => array if all tags returned just one node" do
        # pending 'input = { :tagA => ["valA"], :tagB => ["valB"] }
        #   output = { :tagA => "valA", :tagB => "valB" }'
        expect(matcher_single_node.match_single_nodes).to eq(matcher_result_single_node)
      end

      it "returns an array(size=num_of_nodes) of hashes(single pair always) instead of an hash of arrays" do
        # pending 'input: { :tagA => ["val1A", "val2A"], :tagB => ["val1B", "val2B"] }
        #   output = [ [1] => { :tagA => "val1A", :tagB => "val1B" },
        #              [2] => { :tagA => "val2A", :tagB => "val2B" }'
        expect(matcher.match_many_nodes).to eq(matcher_result)
      end

      it "returns an array of hashed with tags returning a single value being duplicated in all hashes" do
        pending 'input: { :tagA => ["val1A", "val2A"], :tagB => "val1B" }
          output = [ {:tagA => "val1A"}, {:tagA => "val2A"}, {:tagB => "val1B"}, {:tagB => "val1B"}, ]'
      end

    end

    describe "Adder" do

      it "adds specific data to the scraping result array" do
        pending 'input = { :tagA => "valA", :tagB => ["val1B", "val2B"] } -- takes strings and put them in all, takes arrays and distributes them'
      end

    end

  end

end
