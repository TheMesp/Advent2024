# returns 0 or the index that caused the ordering to be rejected.
def check_ordering(rules_hash, vals)
  forbidden = []
  vals.each_with_index do |val, index|
    (forbidden << rules_hash[val.to_i]).flatten!
    return index if forbidden.include?(val.to_i)
  end
  return 0
end

good_sum = 0
bad_sum = 0
rules_hash = {}
File.open("inputs/day5.input", "r") do |f|
  f.each_line do |line|
    if(line =~ /\d+\|\d+/)      
      left, right = line.split("|")
      if rules_hash.has_key? right.to_i
        rules_hash[right.to_i].append(left.to_i)
      else
        rules_hash[right.to_i] = [left.to_i]        
      end
    elsif line =~ /\d+(,\d+)+/
      vals = line.split(",")
      bad_index = check_ordering(rules_hash, vals)
      if bad_index == 0
        good_sum += vals[(vals.size() / 2).to_i].to_i
      else
        while bad_index != 0 do
          vals[bad_index - 1], vals[bad_index] = vals[bad_index], vals[bad_index - 1] # dear god. It's bubble sort. I'm so, so sorry.
          bad_index = check_ordering(rules_hash, vals)
        end
        bad_sum += vals[(vals.size() / 2).to_i].to_i
      end
    end
  end
end
puts good_sum
puts bad_sum