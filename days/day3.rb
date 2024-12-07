total = 0

File.open("inputs/day3.input", "r") do |f|
  f.each_line do |line|
    line.scan(/mul\((\d+),(\d+)\)/).each do |match|
      total += match[0].to_i * match[1].to_i
    end
  end
end
puts total

total = 0

enabled = true
File.open("inputs/day3.input", "r") do |f|
  f.each_line do |line|
    line.scan(/(?:mul\((\d+),(\d+)\))|(do\(\))|(don't\(\))/).each do |left, right, enable, disable|
      enabled = true unless enable.nil?
      enabled = false unless disable.nil?
      total += left.to_i * right.to_i if !(left.nil? || right.nil?) && enabled
    end
  end
end
puts total