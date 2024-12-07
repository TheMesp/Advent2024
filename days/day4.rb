class PuzzleScraper
  @row_data
  @index
  @length
  def initialize(length)
    @length = length
    @row_data = []
  end
  def add_row(row)
    @row_data.append(row)
    @row_data.shift if @row_data.size > @length
  end
  def vertical(index)
    output = ""
    (0..@length - 1).to_a.reverse.each do |row|
      output <<  @row_data[row][index]
    end
    return output
  end
  def diagonal(index)
    output = ""
    (0..@length - 1).to_a.reverse.each_with_index do |row, offset|
      output <<  @row_data[row][index + offset]
    end
    return output
  end
  def off_diagonal(index)
    output = ""
    (0..@length - 1).to_a.reverse.each_with_index do |row, offset|
      output <<  @row_data[row][index - offset]
    end
    return output
  end

  # searches just horizontally for the first three rows, then searches in any non-south direction from there
  def search_for_word(words)
    output = 0
    target_line = @row_data[-1]
    (0..target_line.size()-1).each do |i|
      # horizontals
      output += 1 if i < target_line.size() - @length && words.include?(target_line[i..i+@length-1])
      if(@row_data.size() == @length)
        #verticals
        output += 1 if words.include?(vertical(i))
        #diagonals
        output += 1 if i < target_line.size() - @length && words.include?(diagonal(i))
        output += 1 if i >= @length - 1&& words.include?(off_diagonal(i))
      end
    end
    return output
  end

  # searches just horizontally for the first three rows, then searches in any non-south direction from there
  def search_for_cross(words)
    output = 0
    target_line = @row_data[-1]
    (0..target_line.size()-1).each do |i|
      if(@row_data.size() == @length)
        #check cross
        output += 1 if i < target_line.size() - @length && words.include?(diagonal(i)) && words.include?(off_diagonal(i+@length-1))
      end
    end
    return output
  end
end

p1count = 0
p2count = 0
File.open("inputs/day4.input", "r") do |f|
  scraper1 = PuzzleScraper.new(4)
  scraper2 = PuzzleScraper.new(3)
  f.each_line do |line|
    scraper1.add_row(line)
    scraper2.add_row(line)
    p1count += scraper1.search_for_word(["XMAS", "SAMX"])
    p2count += scraper2.search_for_cross(["MAS", "SAM"])
  end
end
puts p1count
puts p2count