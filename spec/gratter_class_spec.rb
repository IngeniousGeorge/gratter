require_relative "../lib/gratter_class.rb"


describe "gratter" do

  let(:url) { "http://www.livefootball.com" }
  let(:inst) { Gratter.new "http://www.livefootball.com" "//a[@class='btn btnHome']/@href" }
  let(:doc) { inst.parse }

  it "has a URL" do
    expect(inst.url).to eq("http://www.livefootball.com")
  end

  describe "parser" do

    it "returns a Nokogiri document" do
      expect(doc.class).to eql Nokogiri::HTML::Document
    end

  end

  describe "xpather" do

    it "returns a part of a document " do
      expect(doc.xpath("//a[@class='btn btnHome']/@href")).to eq("/")
    end

  end

end
