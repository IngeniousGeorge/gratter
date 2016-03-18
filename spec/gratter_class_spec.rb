require_relative "../lib/gratter_class.rb"


describe "gratter" do

  ## Livefootball
  #let(:url) { "http://www.livefootball.com/football/england/premier-league/league-table/" }
  #let(:xpaths) { { :team => "(//td[@class='ltn'])[position()>1]/text()", :points => "(//td[@class='ltp'])[position()>1]/text()" } }
  #let(:expected_max_num_of_nodes) { 20 }

  ## Livescore
  let(:url) { "http://www.livescore.com/soccer/england/premier-league/" }
  let(:xpaths) { { :team => "(//div[@class='team'])[position()>1]/text()", :points => "(//div[@class='pts tot'])[position()>1]/text()", :league => "//div[@class='left']//a//text()" } }
  let(:expected_max_num_of_nodes) { 20 }

  ## Pitchfork
  # let(:url) { "http://pitchfork.com/reviews/albums/21631-no-one-deserves-happiness/" }
  # let(:xpaths) { { :album => "//h1[@class='review-title']/text()", :artist => "//h2[@class='artists']//a/text()", :rating => "//span[@class='score']/text()" } }
  # let(:expected_max_num_of_nodes) { 1 }

  ## Shared Params
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

  # it "checking => data" do
  #   expect(data).to eq(1)
  # end

  describe "Single Classes" do

    describe "Parser" do

      let(:parser) { Parser.new("http://www.duckduckgo.com") }

      it "returns a Nokogiri document on parse" do
        expect(parser.parse.class).to eql(Nokogiri::HTML::Document)
      end

    end

    describe "Xpather" do

      ## Livefootball
      # let(:xpather) { Xpather.new(Parser.new("http://www.livefootball.com/football/england/premier-league/league-table/").parse, xpaths) }
      # let(:xpaths) { { :team => "(//td[@class='ltn'])[position()>1]/text()", :points => "(//td[@class='ltp'])[position()>1]/text()" } }

      ## Livescore
      let(:xpather) { Xpather.new(Parser.new("http://www.livescore.com/soccer/england/premier-league/").parse, xpaths) }
      let(:xpaths) { { :team => "(//div[@class='team'])[position()>1]/text()", :points => "(//div[@class='pts tot'])[position()>1]/text()", :league => "//div[@class='left']//a//text()" } }
      ## Pitchfork
      # let(:xpather) { Xpather.new(Parser.new("http://pitchfork.com/reviews/albums/21631-no-one-deserves-happiness/").parse, xpaths) }
      # let(:xpaths) { { :album => "//h1[@class='review-title']/text()", :artist => "//h2[@class='artists']//a/text()", :rating => "//span[@class='score']/text()" } }

      ## Shared Params
      let(:data) { xpather.get_data }

      it "has a Nokogiri document to work with" do
        expect(xpather.doc.class).to eql(Nokogiri::HTML::Document)
      end

      it "returns a hash of the same size as the xpaths" do
        expect(data.class).to eql(Hash)
        expect(data.size).to eql(xpaths.size)
      end

      it "returns a non-empty hash" do
        expect(data.first).not_to eq(nil)
        expect(data.values[0]).not_to eq([])
      end

      # it "checking => data" do
      #   expect(data).to eq(1)
      # end

    end

    describe "Adder" do

      let(:xpather_output) { { :tagA => ["valA1", "valA2", "valA3"], :tagB => ["valB1", "valB2", "valB3"], :tagC => ["valC"] } }
      let(:addition) { { :tagD => "valD" } }
      let(:adder) { Adder.new(xpather_output, addition) }

      it "has a hash containing tag => array pairs to work with" do
        expect(adder.data.class).to eq(Hash)
        expect(adder.data.keys[0].class).to eq(Symbol)
        expect(adder.data.values[0].class).to eq(Array)
      end

      it "has a hash with tag => string pairs to add to given data" do
        expect(adder.to_be_added.class).to eq(Hash)
        expect(adder.to_be_added.keys[0].class).to eq(Symbol)
        expect(adder.to_be_added.values[0].class).to eq(String)
      end

      it "adds specific tag => array pairs given as arguments to the data" do
        expect(adder.add_tags.size).to eq(xpather_output.size + addition.size)
        expect(adder.add_tags.class).to eq(Hash)
        expect(adder.add_tags.keys[0].class).to eq(Symbol)
        expect(adder.add_tags.values[0].class).to eq(Array)
        #expect(adder.add_tags).to eq("!")
      end

    end

    describe "Matcher" do

      context "single nodes" do

        let(:xpather_output) { { :tagA => ['valA'], :tagB => ['valB'], :tagC => ['valC'] } }
        let(:matcher) { Matcher.new(xpather_output) }

        it "returns an array with 1 hash in it if given single nodes input" do
          expect(matcher.match.size).to eq(1)
        end

        it "returns an array having 1 hash whose size is the same as number of tags, if given single nodes input" do
          expect(matcher.match[0].size).to eq(xpather_output.size)
        end

      end

      context "arrays differ in size" do

        let(:xpather_faulty_output) { { :tagA => ['valA1', 'valA2', 'valA3'], :tagB => ['valB1', 'valB2'], :tagC => ['valC'] } }
        let(:faulty_matcher) { Matcher.new(xpather_faulty_output) }

        # it "returns an exception if arrays differ in size" do
        #   expect(faulty_matcher.match).to raise_error(ArgumentError)
        # end

      end

      context "mixed" do

        let(:xpather_output) { { :tagA => ["valA1", "valA2", "valA3"], :tagB => ["valB1", "valB2", "valB3"], :tagC => ["valC"] } }
        let(:expected_max_num_of_nodes) { 3 }
        let(:matcher) { Matcher.new(xpather_output) }

        it "has a hash to work with" do
          expect(matcher.data.class).to be(Hash)
        end

        it "returns an array of size expected_max_num_of_nodes" do
          expect(matcher.match.class).to eq(Array)
          expect(matcher.match.size).to eq(expected_max_num_of_nodes)
        end

        it "returns an array of hashes whose size is the same as xpather_output/number of tags" do
          expect(matcher.match[0].class).to eq(Hash)
          expect(matcher.match[0].size).to eq(xpather_output.size)
        end

        it "return nodes in the form of strings" do
          expect(matcher.match[0].values[0].class).to eq(String)
        end

        # it "checking => match" do
        #   expect(matcher.match).to eq(8)
        # end

      end

    end

    describe "Transformer" do

      let(:matcher_output) { [ { :tagA => 'node1A', :tagB => 'node1B' }, { :tagA => 'node2A', :tagB => 'node2B' } ] }
      let(:trans_pattern) { { :tagA => Proc.new { |node| node + ' more stuff' } } }
      let(:transformer) { Transformer.new(matcher_output, trans_pattern) }

      it "has an array of hashes containing sym => string pairs to work with" do
        expect(transformer.data.class).to eq(Array)
        expect(transformer.data[0].class).to eq(Hash)
        expect(transformer.data[0].values[0].class).to eq(String)
      end

      it "transforms the data whose tags are present in the trans_pattern hash" do
        expect(transformer.transform[0].values[0]).to eq("node1A more stuff")
      end

      it "does not change the data whose tags are NOT present in the trans_pattern hash" do
        expect(transformer.transform[0].values[1]).to eq("node1B")
      end

      # it "checking transform" do
      #   expect(transformer.transform).to eq("!")
      # end

    end

    describe "Inserter" do

      let(:transformer_output) { [ { :tagA => 'node1A', :tagB => 'node1B' }, { :tagA => 'node2A', :tagB => 'node2B' } ] }
      let(:con) {  }
      let(:inserter) { Inserter.new( { :data => transformer_output, :connection => con, :table => "table" }) }

      it "has an array of hashes containing sym => string pairs to work with" do
        expect(inserter.data.class).to eq(Array)
        expect(inserter.data[0].class).to eq(Hash)
        expect(inserter.data[0].values[0].class).to eq(String)
      end

      it "adds rows in the db>table" do
        pending
      end

    end

  end

end
