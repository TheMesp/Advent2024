

ListPair = Struct.new(:first, :second)
listPair = ListPair.new([], [])
# create sorted lists as we read the input
File.open("inputs/day1.input", "r") do |f|
  f.each_line do |line|
    items = line.split(/\s+/)
    raise "BAD INPUT #{items}" if(items.size != 2)
    if(listPair.first.empty?)
      listPair.first.push(items[0].to_i)
      listPair.second.push(items[1].to_i)
    else
      firstIndex = listPair.first.bsearch_index{ |other| other >= items[0].to_i }
      secondIndex = listPair.second.bsearch_index{ |other| other >= items[1].to_i }
      listPair.first.insert(firstIndex.nil? ? -1 : firstIndex, items[0].to_i)
      listPair.second.insert(secondIndex.nil? ? -1 : secondIndex, items[1].to_i)
    end
  end
end

output = 0
listPair.first.each_with_index do |addr, index|
  output += (addr - listPair.second[index]).abs()
end

puts output
