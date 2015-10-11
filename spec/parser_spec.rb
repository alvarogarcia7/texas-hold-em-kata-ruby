require 'parser'

RSpec.describe Parser, "#parser" do
  it "should read the file" do
  	read_values = Parser("samples/hand1.hd").read()
  	expect(read_values.lines).to eq 8 
  end
  Parser
end