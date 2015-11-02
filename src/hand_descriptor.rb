class HandDescriptor
  def self.describe(hands)
    new(hands).describe
  end

  def initialize(hands)
    @hands = hands
  end

  def describe
    rules = [Rule::THREE_OF_A_KIND, Rule::TWO_PAIR, Rule::PAIR, Rule::HIGH_CARD]

    rules_that_apply = @hands.map { |hand|
      rules.map { |rule|
        [hand.apply(rule), rule]
      }.select { |x| not x.first[:used].empty? }.reverse
    }.map { |x| x.last }

    rules, rule_value  = rules_that_apply
                             .map { |x| [x[1], rules.index(x[1])] }
                             .transpose

    hands = @hands.each_with_index.map { |hand, index|
      rule = rules[index]
      hand_value = rule_value[index]
      rule_name = method_name(rule, [Rule::HIGH_CARD])
      [hand.cards.map { |x| x.value }.join(' ') + rule_name, hand_value]
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