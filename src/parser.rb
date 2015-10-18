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

  def size
    cards.size
  end

  def empty?
    cards.empty?
  end

  def concat! hand
    cards.concat hand.cards
    nil
  end
end

class EmptyHand < Hand
  attr_accessor :value
  def initialize
    @value = []
  end

  def == other
    return @value == other.value if other.is_a?(EmptyHand)
    false
  end

  def concat! hand
    nil
  end

  def self.empty?
    true
  end
end

class Hand
  EMPTY = EmptyHand
end

class Card
  VALID_RANKS = 'AKQJT98765432'.split('')
  VALID_SUITES = 'cdhs'.split('')
  attr_reader :value

  def initialize value
    @value = value
    raise CardError, "'#{rank}' is not a valid rank" unless VALID_RANKS.include?(rank)
    raise CardError, "'#{suit}' is not a valid suit" unless VALID_SUITES.include?(suit)
  end

  def rank
    value[0]
  end

  def suit
    value[1]
  end

  def ==(another)
    self.value==another.value
  end

  def inspect
    value
  end

end

class Rule
  attr_accessor :block, :name

  def initialize block, name
    @block = block
    @name = name
  end

  def apply hand
    @block.call(hand.cards)
  end

  def self.getFirstAndSecond(sorted_cards)
    first = sorted_cards.first
    if first.nil? then
      first = Hand::EMPTY
    else
      first = Hand.new(first)
    end

    if sorted_cards.size > 1 then
      second = Hand.new(sorted_cards[1])
    else
      second = Hand::EMPTY
    end
    return first, second
  end

  HIGH_CARD = Rule.new(
      lambda { |cards|
        sorted_cards = cards
                           .map { |x| [x, Card::VALID_RANKS.index(x.rank)]}
                           .sort_by { |f| f[1]}
                           .map { |x| x.first}
        used = sorted_cards.first
        kicker = sorted_cards[1]
        if kicker.nil? then
          kicker = Hand::EMPTY
        else
          kicker = Hand.new([kicker])
        end
        {used: Hand.new([used]), kicker: kicker}
      }, "High card")

  PAIR = Rule.new(
      lambda { |cards|
        card_frequencies = cards
                               .group_by{|x| x.rank}
                               .values.map{|x| [x.count, x]}
                               .select{|x| x.first==2}
                               .map { |x| x[1]}
                               .map { |x| [x, Card::VALID_RANKS.index(x[1].rank)]}
                               .sort_by { |f| f[1]}
                               .map { |x| x.first}

        used, kicker = getFirstAndSecond card_frequencies
        {used: used, kicker: kicker}
      }, "Pair")


  TWO_PAIR = Rule.new(
        lambda { |cards|
          pair = PAIR.apply(Hand.new(cards))
          used = pair[:used]
          kicker = pair[:kicker]
          if used.empty? or kicker.empty? then
            used = Hand::EMPTY
          else
            used.concat! kicker
          end
          {used: used, kicker: Hand::EMPTY}
      }, "Two Pair")

  THREE_OF_A_KIND = Rule.new(
      lambda { |cards|
        card_frequencies = cards
                               .group_by{|x| x.rank}
                               .values.map{|x| [x.count, x]}
                               .select{|x| x.first==3}
                               .map { |x| x[1]}
                               .map { |x| [x, Card::VALID_RANKS.index(x[1].rank)]}
                               .sort_by { |f| f[1]}
                               .map { |x| x.first}

        used, kicker = getFirstAndSecond(card_frequencies)
        {used: used, kicker: kicker}
      }, "Three of a kind")

end


class CardError < StandardError
end