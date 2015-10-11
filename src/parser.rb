class Parser
  def initialize file
    @file = file
  end

  def lines
  	lines = []
    File.open(@file, "r") {
 	  |io| io.map { |line| lines << line.strip }
 	}
    lines
  end

end