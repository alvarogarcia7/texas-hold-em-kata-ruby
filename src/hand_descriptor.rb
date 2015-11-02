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
    most_valuable_rule = applied_non_empty_rules
                             .map { |x| x.last }
                             .map { |x| [*x, rules.index(x[1])] }
    # idea:
    # [15] pry(main)> [nil, nil].zip([1,2],[1,2])
    # => [[nil, 1, 1], [nil, 2, 2]]
    # [16] pry(main)> [0, 0].zip([1,2],[1,2])
    # => [[0, 1, 1], [0, 2, 2]]

    # p hand_with_type_with_rule_index
    desc = @hands.each_with_index.map { |hand, index|
      rule = most_valuable_rule[index][1]
      rule_name = if rule == Rule::HIGH_CARD then
                    ''
                  else
                    " #{rule.name}"
                  end
      [hand.cards.map { |x| x.value }.join(' ') + rule_name, most_valuable_rule[index][2]]
    }

    winner_hand = most_valuable_rule.map { |x| x[2] }.min

    desc.select { |x| x[1] == winner_hand }.first[0] += ' (winner)'

    desc.map! { |x| x.first }
    return desc.join "\n"
  end

  def apply_next(rule)
    @hands.map { |hand| (hand.apply rule)[:used] }
  end
end