require_relative "../lib/gratter_class.rb"


describe "gratter" do

  let(:url) { "http://www.livefootball.com" }
  let(:inst) { Gratter.new "http://www.livefootball.com" }

  it "has a URL" do
    raise unless Gratter.new("http://www.livefootball.com").url == "http://www.livefootball.com"
  end

  it "returns a Nokogiri document" do
    doc = inst.simple_parse
    expect(doc.class).to eql Nokogiri::HTML::Document
  end

end
