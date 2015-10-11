require File.expand_path(File.dirname(__FILE__) + '/../src/parser.rb')

RSpec.describe "Canary test" do
  it "should always pass" do
    expect(true).to eq true
  end
end

RSpec.describe "#parser" do
  it "should read the file" do
  	read_values = Parser.new(File.dirname(__FILE__)+"/samples/hand1.hd")
  	expect(read_values.lines).to eq [
      "4s Kd 2h Ts 5h Jc",
      "8h Ad 2h Ts 5h",
      "2c 6s 2h Ts 5h",
      "4d Tc 2h Ts 5h Jc",
      "Jh 3d 2h Ts 5h Jc Qd",
      "4h As",
      "9d Jd",
      "7s 4c 2h Ts 5h Jc"
    ]
  end
end

RSpec.describe "card reader" do
  it "should parse a hand" do
    sut = Reader.new("4s Kd 2h Ts 5h Jc")
    expect(sut.convert).to eq Hand.new(
      [Card.new("4s"),
      Card.new("Kd"),
      Card.new("2h"),
      Card.new("Ts"),
      Card.new("5h"),
      Card.new("Jc")])
  end
end

RSpec.describe "Cards" do
  it "should detect a valid card" do
    expect(Card.new("4s").value).to eq "4s"
  end
  it "should detect an invalid card" do
    expception = assert_raise(CardError) do
      Card.new("1s")
    end
    assert_match(/1 is not a valid number/, expception.message)
  end

  it "should detect an invalid suit" do
    expception = assert_raise(CardError) do
      Card.new("4a")
    end
    assert_match(/a is not a valid suit/, expception.message)
  end
end



def assert_raise(exception)
  begin
    yield
  rescue Exception => ex
    expected = ex.is_a?(exception)
    assert(expected, "Exception #{exception.inspect} expected, but #{ex.inspect} was raised")
    return ex
  end
  flunk "Exception #{exception.inspect} expected, but nothing raised"
end

def assert_match(pattern, actual, msg=nil)
  msg ||= "Expected #{actual.inspect} to match #{pattern.inspect}"
  assert pattern =~ actual, msg
end

def flunk(msg)
  raise FailedAssertionError, msg
end

def assert(condition, msg=nil)
  msg ||= "Failed assertion."
  flunk(msg) unless condition
  true
end