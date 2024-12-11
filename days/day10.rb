require 'set'

Coordinate2D = Struct.new(:x, :y) do
end

class Map
  attr_reader :data, :trailheads
  
  def initialize()
    @data = []
    @trailheads = []
    @visited_nines = Set[]
  end
  def add_row(row)
    int_row = []
    row.each_char.with_index do |char, index|
      int_row.append char.to_i
      if(char == '0')
        @trailheads.append(Coordinate2D.new(index,@data.size))
      end
    end
    @data.append(int_row)    
  end

  def follow_trail(curr)
    curr_elevation = @data[curr.y][curr.x]
    if curr_elevation == 9
      @visited_nines.add(curr)
      return 1
    else
      output = 0
      valid_directions = []
      if(curr.x > 0)
        valid_directions.append(Coordinate2D.new(curr.x - 1, curr.y))
      end
      if(curr.y > 0)
        valid_directions.append(Coordinate2D.new(curr.x, curr.y - 1))
      end
      if(curr.x < @data[curr.y].size()-1)
        valid_directions.append(Coordinate2D.new(curr.x + 1, curr.y))
      end
      if(curr.y < @data.size()-1)
        valid_directions.append(Coordinate2D.new(curr.x, curr.y + 1))
      end
      valid_directions.each do |n|
        output += follow_trail(n) if @data[n.y][n.x] == curr_elevation + 1        
      end
      return output
    end
  end

  def solve
    p1 = 0
    p2 = 0
    @trailheads.each do |trailhead|
      p2 += follow_trail(trailhead)
      p1 += @visited_nines.size()
      @visited_nines.clear()
    end
    puts "#{p1} #{p2}"
  end
end

File.open("inputs/day10.input", "r") do |f|
  map = Map.new
  f.each_line do |line|
    map.add_row(line.strip)
  end
  map.solve

end
