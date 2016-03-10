require_relative "../lib/gratter_class.rb"


describe "gratter" do

  let(:inst) { Gratter.new("http://www.livefootball.com", "//a[@class='btn btnHome']/@href") }

  it "has a URL" do
    expect(inst.url).to eq("http://www.livefootball.com")
  end

  it "returns a piece of a document" do
    piece = inst.use
    expect(piece).to eq("/")
  end

end

describe "Single Classes" do

#  let(:doc) { }

# it "returns a Nokogiri document" do
#   doc = inst.use
#   expect(doc.class).to eql Nokogiri::HTML::Document
# end

end
