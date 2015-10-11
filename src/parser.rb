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
  attr_reader :value

  def initialize value
    @value = value
  end

  def ==(another)
    self.value==another.value
  end
end