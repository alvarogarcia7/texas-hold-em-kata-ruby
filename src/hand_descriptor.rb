class HandDescriptor
  def self.describe(hands)
    new(hands).describe
  end

  def initialize(hands)
    @hands = hands
  end

  def describe
    rules = [Rule::THREE_OF_A_KIND, Rule::TWO_PAIR, Rule::PAIR, Rule::HIGH_CARD]

    applied_non_empty_rules = @hands.map { |hand|
      rules.map { |rule|
        [hand.apply(rule), rule]
      }.select { |x| not x.first[:used].empty? }.reverse
    }
    s3,s4  = applied_non_empty_rules
                             .map { |x| x.last }
                             .map { |x| [x[1], rules.index(x[1])] }
                             .transpose

    # p hand_with_type_with_rule_index
    desc = @hands.each_with_index.map { |hand, index|
      rule = s3[index]
      rule_name = method_name(rule, [Rule::HIGH_CARD])
      [hand.cards.map { |x| x.value }.join(' ') + rule_name, s4[index]]
    }

    winner_hand = s4.map { |x| x[1] }.min

    desc.select { |x| x[1] == winner_hand }.first[0] += ' (winner)'

    hands = desc.map { |x| x.first }
    return hands.join "\n"
  end

  def method_name(rule, exceptions)
    if exceptions.include? rule then
      ''
    else
      " #{rule.name}"
    end
  end

  def apply_next(rule)
    @hands.map { |hand| (hand.apply rule)[:used] }
  end
end