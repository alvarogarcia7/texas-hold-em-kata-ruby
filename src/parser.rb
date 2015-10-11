class Parser
  def initialize file
    @file = file
  end

  def lines
  	lines = 0
    File.open(@file, "r") {
 	  |io| io.map { |line| lines += 1 }
 	}
    lines
  end

end