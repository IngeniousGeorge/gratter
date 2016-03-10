require_relative "../lib/gratter_class.rb"


describe "gratter" do

  let(:url) { "http://www.livefootball.com" }
  let(:inst) { Gratter.new "http://www.livefootball.com" }

  it "has a URL" do
    raise unless Gratter.new("http://www.livefootball.com").url == url
  end

  it "returns a Nokogiri document" do
    doc = inst.use
    expect(doc.class).to eql Nokogiri::HTML::Document
  end

end
