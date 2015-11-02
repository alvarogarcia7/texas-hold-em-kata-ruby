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
    rules, rule_value  = applied_non_empty_rules
                             .map { |x| x.last }
                             .map { |x| [x[1], rules.index(x[1])] }
                             .transpose

    hands = @hands.each_with_index.map { |hand, index|
      rule = rules[index]
      rule_name = method_name(rule, [Rule::HIGH_CARD])
      [hand.cards.map { |x| x.value }.join(' ') + rule_name, rule_value[index]]
    }.each { |x| if x[1] == rule_value.min then x[0] += ' (winner)' end }
    .map { |x| x.first }

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