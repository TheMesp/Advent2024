good_reports = 0
good_reports_with_removal = 0

def parse_line(values)
  ascending = values[0].to_i < values[1].to_i
  prev = nil
  values.each_with_index do |value, index|
    unless index == 0
      diff = value.to_i - prev
      diff *= -1 unless ascending
      good_report = diff >= 1 && diff <= 3
      return index unless good_report        
    end
    prev = value.to_i
  end
  return 0
end

File.open("inputs/day2.input", "r") do |f|
  f.each_line do |line|
    values = line.split(/\s+/)
    
    bad_index = parse_line(values)
    
    if bad_index == 0
      good_reports += 1
    else
      if parse_line(values.reject.with_index{|value, index| index == bad_index}) == 0
        good_reports_with_removal += 1         
      elsif parse_line(values.reject.with_index{|value, index| index == bad_index - 1}) == 0
        # Handles 7 9 5 4 3 case where we're fooled into thinking it ascends and mark 5 as the bad number
        good_reports_with_removal += 1
      elsif bad_index > 1 && parse_line(values.reject.with_index{|value, index| index == bad_index - 2}) == 0
        # Handles 7 9 8 6 4 case where we're once again fooled into thinking it's ascending, and removing the first number is the right case
        good_reports_with_removal += 1
      end
      # I categorically refuse to try every possible removal, as that turns this algo into O(n^2). Here we can keep it O(n).
    end
  end
end

puts good_reports

puts good_reports_with_removal + good_reports