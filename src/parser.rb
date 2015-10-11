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
  attr_reader :cards
  def initialize *args
    @cards = args
  end

  def ==(another)
    cards==another.cards
  end
end

class Card
  VALID_VALUES = "AKQJT98765432".split("")
  attr_reader :value

  def initialize value
    facial_value = value[0]
    raise CardError, "#{facial_value} is not a valid number" if not VALID_VALUES.include?(facial_value)
    @value = value
  end

  def ==(another)
    self.value==another.value
  end
end

class CardError < StandardError
end