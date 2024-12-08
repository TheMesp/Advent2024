# I think we're going to have to load this entire file into memory, Steven.
# Damn.

Guard = Struct.new(:x, :y, :direction) do
  def direction_to_c
    if(direction == :up)
      return 'U'
    elsif(direction == :left)
      return 'L'
    elsif(direction == :down)
      return 'D'
    elsif(direction == :right)
      return 'R'
    else
      return '?'
    end
  end
end

class Maze
  attr_reader :count, :data, :loops, :guard
  
  def initialize()
    @data = []
    @guard = Guard.new(0,0,:up)
    @count = 0
    @loops = 0
  end
  def add_row(row)
    @data.append(row)
    if(row.include? '^')
      @guard.x = row.index('^')
      @guard.y = @data.size() - 1
      @data[@guard.y][@guard.x] = '.'
      @count = 1
    end
  end

  def initialize_copy(original_maze)
    @guard = original_maze.guard.dup
    @data = []
    original_maze.data.each do |row|
      @data.append(row.dup)
    end
  end
  # inserts an obstacle in front of the guard, returns false if it cannot (due to already being traversed)
  def insert_obstacle
    nextx, nexty = @guard.x, @guard.y
    if(@guard.direction == :up)
      nexty -= 1
    elsif(@guard.direction == :down)
      nexty += 1
    elsif(@guard.direction == :left)
      nextx -= 1
    elsif(@guard.direction == :right)
      nextx += 1
    end
    if(@data[nexty][nextx] == '.')
      @data[nexty][nextx] = '#'
      return true
    else
      return false
    end
  end

  # returns true if a loop was encountered
  def move_guard(check_for_loops)
    while true do
      nextx, nexty = @guard.x, @guard.y
      if(@guard.direction == :up)
        nexty -= 1
      elsif(@guard.direction == :down)
        nexty += 1
      elsif(@guard.direction == :left)
        nextx -= 1
      elsif(@guard.direction == :right)
        nextx += 1
      end
      return false if nexty < 0 || nextx < 0 || nexty >= @data.size() || nextx >= @data[@guard.y].size() # we out here
      if  @data[nexty][nextx] == '#'
        # ugly. TODO fix this into a modulo or something later
        if(@guard.direction == :up)
          @guard.direction = :right
        elsif(@guard.direction == :down)
          @guard.direction = :left
        elsif(@guard.direction == :left)
          @guard.direction = :up
        elsif(@guard.direction == :right)
          @guard.direction = :down
        end                
      else
        if(check_for_loops)
          what_if = self.dup          
          @loops += 1 if what_if.insert_obstacle && what_if.move_guard(false)              
        end
        return true if @data[@guard.y][@guard.x] == @guard.direction_to_c # LOOP!
        @data[@guard.y][@guard.x] = @guard.direction_to_c
        @guard.x, @guard.y = nextx, nexty
        @count += 1 if @data[@guard.y][@guard.x] !~ /[UDLR]/        
      end
    end
  end
end

File.open("inputs/day6.input", "r") do |f|
  maze = Maze.new()
  f.each_line do |line|
    maze.add_row(line.strip)
  end
  maze.move_guard(true)
  puts maze.count
  puts maze.loops
end
