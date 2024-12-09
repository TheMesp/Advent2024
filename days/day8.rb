require 'set'

Coordinate2D = Struct.new(:x, :y) do
  def to_s()
    return "(#{x},#{y})"
  end
  def inbounds(xmax, ymax)
    return x >= 0 && y >= 0 && x <= xmax && y <= ymax
  end
  # returns an array of all possible resonances, given a coordinate and two diffs
  def generate_resonances(xdiff, ydiff, xmax, ymax)
    output = [self.dup]
    interval = 1
    resonant_coords = Coordinate2D.new(x + xdiff * interval, y + ydiff * interval)
    while(resonant_coords.inbounds(xmax,ymax))
      output.append(resonant_coords.dup)
      interval += 1
      resonant_coords = Coordinate2D.new(x + xdiff * interval, y + ydiff * interval)
    end
    interval = -1
    resonant_coords = Coordinate2D.new(x + xdiff * interval, y + ydiff * interval)
    while(resonant_coords.inbounds(xmax,ymax))
      output.append(resonant_coords.dup)
      interval -= 1
      resonant_coords = Coordinate2D.new(x + xdiff * interval, y + ydiff * interval)
    end
    return output
  end
end



# returns an array of all possible antenodes that can be generated given a set of attennae.
def generate_antenodes(attennae, xmax, ymax, resonance)
  output = []
  attennae.combination(2).each do |pair|
    puts "#{pair[0].to_s} and #{pair[1].to_s}"
    xdiff = pair[1].x - pair[0].x
    ydiff = pair[1].y - pair[0].y    
    if resonance
      output.append(pair[0].generate_resonances(xdiff,ydiff,xmax,ymax))
    else
      ante1 = Coordinate2D.new(pair[1].x + xdiff,pair[1].y + ydiff)
      ante2 = Coordinate2D.new(pair[0].x - xdiff,pair[0].y - ydiff)
      output.append(ante1) if ante1.inbounds(xmax, ymax)
      output.append(ante2) if ante2.inbounds(xmax, ymax)
    end
  end
  return output
end
File.open("inputs/day8.simpleinput", "r") do |f|
  attennae_hash = Hash.new()
  antenode_set = Set[]
  resonance_set = Set[]
  y = 0
  xmax = 0
  ymax = 0
  f.each_line do |line|
    line = line.strip
    xmax = line.size - 1 if xmax == 0
    (0..line.size - 1).each do |x|
      char = line[x]
      if(char != '.')
        if attennae_hash.has_key? char
          attennae_hash[char].append(Coordinate2D.new(x,y))
        else
          attennae_hash[char] = [Coordinate2D.new(x,y)]
        end
      end
    end
    y += 1
  end

  ymax = y - 1

  puts attennae_hash
  attennae_hash.each_value do |attennae|
    # antenode_set.merge(generate_antenodes(attennae, xmax, ymax, false))
    resonance_set.merge(generate_antenodes(attennae, xmax, ymax, true))
  end
  # puts antenode_set.size()
  puts resonance_set.size()
end