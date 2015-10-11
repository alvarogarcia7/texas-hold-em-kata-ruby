class Parser
  def initialize file
    @file = file
  end

  def lines
  	lines = []
    File.open(@file, 'r') {
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
    cards = @representation.split(' ').map { |card| Card.new(card) }
    Hand.new(cards)
  end
end

class Hand
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

  def self.from representation
    Reader.new(representation).convert
  end
end

class EmptyHand < Hand
  def initialize
    @value = []
  end

  def == other
    true
  end
end

class Hand
  EMPTY = EmptyHand
end

class Card
  VALID_VALUES = 'AKQJT98765432'.split('')
  VALID_SUITES = 'cdhs'.split('')
  attr_reader :value

  def initialize value
    facial_value = value[0]
    suit = value[1]
    raise CardError, "'#{facial_value}' is not a valid number" unless VALID_VALUES.include?(facial_value)
    raise CardError, "'#{suit}' is not a valid suit" unless VALID_SUITES.include?(suit)
    @value = value
  end

  def ==(another)
    self.value==another.value
  end

  def inspect
    value
  end

  def face
    value[0]
  end
end



def seccond x
  x[1]
end

class Rule
  attr_accessor :block

  def initialize block
    @block = block
  end

  def apply hand
    @block.call(hand.cards)
  end

  HIGH_CARD = Rule.new(
      lambda { |cards|
        sorted_cards = cards.map { |x| [x, Card::VALID_VALUES.index(x.face)]}.sort_by { |f| f[1]}.map { |x| x[0]}
        used = sorted_cards[0]
        kicker = sorted_cards[1]
        if kicker.nil? then
          kicker = Hand::EMPTY
        else
          kicker = Hand.new([kicker])
        end
        # unused = sorted_cards
        # unused.delete(kicker)
        # unused.delete(used)
        # unused = Hand::EMPTY if unused.size == 0
        # unused: Hand.new([unused])
        {used: Hand.new([used]), kicker: kicker}
      })

end


class CardError < StandardError
end