class Parser
  def initialize file
    @file = file
  end

  def lines
  	lines = []
    File.open(@file, "r") {
 	    |io| io.map { |line| lines << line.strip }
 	  }
    lines
  end

end

class Reader
  def initialize representation
    @representation = representation
  end

  def convert
    cards = @representation.split(" ").map { |card| Card.new(card) }
    return Hand.new(cards)
  end
end

class Hand
  EMPTY = nil
  attr_reader :cards
  def initialize args
    @cards = args
  end

  def ==(another)
    cards==another.cards
  end

  def inspect
    cards.map { |x| x.inspect }
  end

  def apply rule
    rule.apply self
  end
end

class Card
  VALID_VALUES = "AKQJT98765432".split("")
  VALID_SUITES = "cdhs".split("")
  attr_reader :value

  def initialize value
    facial_value = value[0]
    suit = value[1]
    raise CardError, "'#{facial_value}' is not a valid number" if not VALID_VALUES.include?(facial_value)
    raise CardError, "'#{suit}' is not a valid suit" if not VALID_SUITES.include?(suit)
    @value = value
  end

  def ==(another)
    self.value==another.value
  end

  def inspect
    value
  end
end

class Rule
  def initialize &block
    @block = block
  end

  def apply hand
    return { :used => hand, :kicker => Hand::EMPTY}
  end

end

class CardError < StandardError
end