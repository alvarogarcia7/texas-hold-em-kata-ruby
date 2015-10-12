require File.expand_path(File.dirname(__FILE__) + '/../src/parser.rb')

RSpec.describe 'Canary test' do
  it 'should always pass' do
    expect(true).to eq true
  end
end

RSpec.describe '#parser' do
  it 'should read the file' do
  	read_values = Parser.new(File.dirname(__FILE__)+'/samples/hand1.hd')
  	expect(read_values.lines).to eq [
      '4s Kd 2h Ts 5h Jc',
      '8h Ad 2h Ts 5h',
      '2c 6s 2h Ts 5h',
      '4d Tc 2h Ts 5h Jc',
      'Jh 3d 2h Ts 5h Jc Qd',
      '4h As',
      '9d Jd',
      '7s 4c 2h Ts 5h Jc'
    ]
  end
end

RSpec.describe 'card reader' do
  it 'should parse a hand' do
    sut = Reader.new('4s Kd 2h Ts 5h Jc')
    expect(sut.convert).to eq Hand.new(
      [Card.new('4s'),
      Card.new('Kd'),
      Card.new('2h'),
      Card.new('Ts'),
      Card.new('5h'),
      Card.new('Jc')])
  end
end

RSpec.describe 'Cards' do
  it 'should detect a valid card' do
    expect(Card.new('4s').value).to eq '4s'
  end
  it 'should detect an invalid card' do
    expect{Card.new('1s')}.to raise_error(CardError,/'1' is not a valid number/)
  end

  it 'should detect an invalid suit' do
    expect{Card.new('4a')}.to raise_error(CardError,/'a' is not a valid suit/)
  end
end


RSpec.describe 'Hand - Rule application' do
  it 'should apply the high card' do
    hand = Reader.new('4s').convert
    expected_result = { :used => hand, :kicker => Hand::EMPTY}
    actual_result = hand.apply(Rule::HIGH_CARD)
    expect(actual_result).to eq(expected_result)
  end
end

RSpec.describe 'Rule application' do
  it 'should apply the higher card rule to a single card' do
    expect(Rule::HIGH_CARD.apply(Hand.from('5s'))).to eq ({:used => Hand.from('5s'), :kicker => Hand::EMPTY})
  end

  it 'should apply the higher card rule to two cards' do
    rule = Rule::HIGH_CARD
    initial_hand = Hand.from('4s 5s')
    expect(rule.apply(initial_hand)).to eq({used: Hand.from('5s'), kicker: Hand.from('4s')})
  end
end

RSpec.describe "EmptyHand#==" do
  it "should find it equal to itself" do
    expect(EmptyHand.new).to eq(EmptyHand.new)
  end

  it "should not be equal to a Hand" do
    expect(EmptyHand.new).to_not eq(Hand.new([]))
  end
end

RSpec.describe 'Hand - Creation of this class' do
  it 'should create from a string' do
    expect(Hand.from('4s 5s')).to eq Hand.new([Card.new('4s'), Card.new('5s')])
  end
end

RSpec.describe 'End to End' do
  xit 'should parse all hands in a file' do
    lines = Parser.new(File.dirname(__FILE__)+'/samples/hand1.hd').lines
    hands = lines.map { |x| Reader.new(x).convert }
    hands.map { |x| puts x.inspect }
    hands.map { |x| puts x }
  end
end