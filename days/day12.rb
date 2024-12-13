Coordinate2D = Struct.new(:x, :y) do
end
Region = Struct.new(:coords, :perimeter, :plant, :sides) do
end

class Garden
  attr_reader :regions
  def initialize()
    @regions = []
    @data = []
    @region_data = []
  end

  def data_or_empty(coord,xmax,ymax)
    return coord.x.between?(0,xmax) && coord.y.between?(0,ymax) ? @data[coord.y][coord.x] : '.'
  end

  def add_row(row)
    @data.append(row)
    @region_data.append(Array.new(row.size(), nil))
  end

  def fill_region(x,y,xmax,ymax,region)
    region.coords.append(Coordinate2D.new(x,y))
    @region_data[y][x] = region
    [Coordinate2D.new(x-1,y), Coordinate2D.new(x+1,y), Coordinate2D.new(x,y-1), Coordinate2D.new(x,y+1)].each do |coord|
      if(coord.x.between?(0,xmax) && coord.y.between?(0,ymax))
        if(@data[coord.y][coord.x] == region.plant)
          fill_region(coord.x,coord.y,xmax,ymax,region) if @region_data[coord.y][coord.x].nil?
        else
          region.perimeter += 1
        end        
      else
        region.perimeter += 1
      end
    end
    # check for corners
    [
      [Coordinate2D.new(x-1,y), Coordinate2D.new(x-1,y-1), Coordinate2D.new(x,y-1)],
      [Coordinate2D.new(x,y-1), Coordinate2D.new(x+1,y-1), Coordinate2D.new(x+1,y)],
      [Coordinate2D.new(x+1,y), Coordinate2D.new(x+1,y+1), Coordinate2D.new(x,y+1)],
      [Coordinate2D.new(x,y+1), Coordinate2D.new(x-1,y+1), Coordinate2D.new(x-1,y)]
    ].each do |cornergroup|
      side1, diagonal, side2 = data_or_empty(cornergroup[0],xmax,ymax), data_or_empty(cornergroup[1],xmax,ymax), data_or_empty(cornergroup[2],xmax,ymax)
      curr = @data[y][x]
      region.sides += 1 if curr != diagonal && curr == side1 && curr == side2 # inner corners
      region.sides += 1 if curr != side1 && curr != side2 # outer corners
     end
  end

  def populate_regions
    @data.each_with_index do |row, y|
      (0..row.size()-1).each do |x|
        if @region_data[y][x].nil?
          region = Region.new([], 0, @data[y][x], 0)
          fill_region(x,y,row.size-1,@data.size-1,region)
          @regions.append(region)
        end
      end
    end
  end
end

File.open("inputs/day12.input", "r") do |f|
  garden = Garden.new()
  f.each_line do |line|
    garden.add_row(line.strip)
  end
  garden.populate_regions
  p1 = 0
  p2 = 0
  garden.regions.each do |region|
    puts "#{region.plant}: perimeter = #{region.perimeter}, total area = #{region.coords.size()}, sides = #{region.sides}"
    p1 += region.coords.size() * region.perimeter
    p2 += region.coords.size() * region.sides
  end
  puts p1
  puts p2
end