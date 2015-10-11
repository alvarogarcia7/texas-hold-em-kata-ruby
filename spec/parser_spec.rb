require File.expand_path(File.dirname(__FILE__) + '/../src/parser.rb')

RSpec.describe "Canary test" do
  it "should always pass" do
    expect(true).to eq true
  end
end

RSpec.describe "#parser" do
  it "should read the file" do
  	read_values = Parser.new(File.dirname(__FILE__)+"/samples/hand1.hd")
  	expect(read_values.lines).to eq 8 
  end
end
