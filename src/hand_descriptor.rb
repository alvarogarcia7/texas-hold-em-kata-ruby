class Array
  def select_attribute attr
    self.map { |unit| unit[attr] }
  end

  def apply2_with_index &block
    self.each_with_index.map{ |element,index|
      function = block.()
      function.(element,index)
    }
  end
end


class HandDescriptor
  def self.describe(hands)
    new(hands).describe
  end

  def initialize(hands)
    @hands = hands
  end

  def describe
    rules = [Rule::THREE_OF_A_KIND, Rule::TWO_PAIR, Rule::PAIR, Rule::HIGH_CARD]

    apply_rules rules

    sort rules

    describe_hands
  end

  def most_valuable_rule? hand
    hand[:value] == @rule_value.min
  end

  def describe_hands
    hands = @hands.apply2_with_index{ method(:obtain_description) }
    
    mark_most_valuable! hands
    
    mark_winner! hands

    hands = hands.select_attribute :description

    return prepare_descriptions hands
  end

  def prepare_descriptions hands
    hands.join "\n"
  end

  def mark_most_valuable! hands
    hands.each { |hand|
     if most_valuable_rule? hand
       hand[:winner] = true
     end
    }
  end

  def mark_winner! hands
    winners = find_winners hands
    if one? winners
      winners.first[:description] += ' (winner)'
    end
  end

  def one? hands
    hands.size == 1
  end

  def find_winners hands
    hands.select {|hand| hand[:winner]}
  end

  def obtain_description hand, index
    rule = @rules[index]
    hand_value = @rule_value[index]
    rule_name = method_name(rule, [Rule::HIGH_CARD])
    {description: hand.describe_as(rule_name), value: hand_value}
  end

  private

  def sort rules
     @rules, @rule_value = @rules_that_apply
       .map { |x| [x, rules.index(x)] }
       .transpose
  end

  def apply_rules rules
    @rules_that_apply = @hands.map { |hand|
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
    @hands.map { |hand| (hand.apply rule) }
          .select_attribute :used
  end
end