class Enumerator
  def apply2 &block
    self.map{ |x,y|
      f = block.()
      f.(x,y)
    }
  end
end

class Array
  def select_attribute attr
    self.map { |x| x[attr] }
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


  def describe_hands
    hands = @hands.each_with_index.apply2{ method(:obtain_description) }
    .each { |x| if x[:value] == @rule_value.min then x[:winner] = true end }
    
    if hands.count {|hand| hand[:winner]} == 1
      hands.each { |x| if x[:value] == @rule_value.min then x[:description] += ' (winner)' end }
    end
    hands = hands.select_attribute :description

    return hands.join "\n"
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