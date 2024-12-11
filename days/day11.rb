$hash = Hash.new
def eval_stone(stone, iterations, target_iterations)
  return 1 if iterations >= target_iterations
  output = 0
  stone_string = stone.to_s
  stones = []
  if stone == 0
    stones.append(1)
  elsif stone_string.size % 2 == 0
    # I could be doing / and % here. But I'm lazy.
    stones.append(stone_string[0..stone_string.size/2-1].to_i)
    stones.append(stone_string[stone_string.size/2..-1].to_i)
  else
    stones.append(stone * 2024)
  end
  stones.each do |stone|
    unless $hash.has_key? stone
      $hash[stone] = Array.new(target_iterations, 0)
    end
    $hash[stone][iterations] = eval_stone(stone, iterations+1, target_iterations) if $hash[stone][iterations] == 0
    output += $hash[stone][iterations]
  end
  return output
end

File.open("inputs/day11.input", "r") do |f|
  f.each_line do |line|
    stones = []
    line.strip.split(" ").each do |num|
      stones.append(num.to_i)
    end
    output = 0
    stones.each do |stone|
      output += eval_stone(stone, 0, 75)
    end
    puts "#{output}"
  end
end