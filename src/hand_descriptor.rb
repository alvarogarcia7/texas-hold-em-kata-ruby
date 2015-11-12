class HandDescriptor
  def self.describe(hands)
    new(hands).describe
  end

  def initialize(hands)
    @hands = hands
  end

  def describe
    rules = [Rule::THREE_OF_A_KIND, Rule::TWO_PAIR, Rule::PAIR, Rule::HIGH_CARD]

    rules_that_apply = apply_rules rules

    rules, rule_value  = rules_that_apply
                             .map { |x| [x, rules.index(x)] }
                             .transpose


    hands = @hands.each_with_index.map { |hand, index|
      rule = rules[index]
      hand_value = rule_value[index]
      rule_name = method_name(rule, [Rule::HIGH_CARD])
      {description: hand.describe_as(rule_name), value: hand_value}
    }.each { |x| if x[:value] == rule_value.min then x[:winner] = true end }
    
    if hands.count {|hand| hand[:winner]} == 1
      hands.each { |x| if x[:value] == rule_value.min then x[:description] += ' (winner)' end }
    end
    hands.map! { |x| x[:description]}

    return hands.join "\n"
  end

  private

  def apply_rules rules
    rules_that_apply = @hands.map { |hand|
      rules.map { |rule|
        [hand.apply(rule), rule]
      }.select { |x| not x.first[:used].empty? }.reverse
    }.map { |x| x.last }
    .map { |x| x.last }
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