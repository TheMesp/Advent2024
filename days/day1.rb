

ListPair = Struct.new(:first, :second)
listPair = ListPair.new([], [])

similarityHash = Hash.new(0)

# create sorted lists as we read the input
File.open("inputs/day1.input", "r") do |f|
  f.each_line do |line|
    items = line.split(/\s+/)
    raise "BAD INPUT #{items}" if(items.size != 2)

    firstIndex = listPair.first.bsearch_index{ |other| other >= items[0].to_i }
    secondIndex = listPair.second.bsearch_index{ |other| other >= items[1].to_i }
    listPair.first.insert(firstIndex.nil? ? -1 : firstIndex, items[0].to_i)
    listPair.second.insert(secondIndex.nil? ? -1 : secondIndex, items[1].to_i)
    similarityHash[items[1].to_i] += 1 # One day ruby will have ++
  end
end

totalDifference = 0
similarityScore = 0

listPair.first.each_with_index do |addr, index|
  totalDifference += (addr - listPair.second[index]).abs()
  similarityScore += addr * similarityHash[addr]
end

puts totalDifference
puts similarityScore