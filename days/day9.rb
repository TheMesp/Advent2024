Block = Struct.new(:size, :id) do
  def to_s()
    return (id == :blank ? "." : "#{id}") * size
  end
end
File.open("inputs/day9.input", "r") do |f|
  f.each_line do |line|
    line = line.strip
    uncompressed_array = []
    block_array = []
    free = false
    next_id = 0
    line.each_char do |char|
      if free
        free = false
        uncompressed_array.concat(Array.new(char.to_i, :blank))
        block_array.append(Block.new(char.to_i, :blank))
      else
        free = true
        uncompressed_array.concat(Array.new(char.to_i, next_id))
        block_array.append(Block.new(char.to_i, next_id))
        next_id += 1
      end 
    end
    front = 0
    back = uncompressed_array.size() - 1
    while(front < back) do
      if(uncompressed_array[front] == :blank)
        while(front < back && uncompressed_array[back] == :blank)
          back -= 1
        end
        uncompressed_array[front], uncompressed_array[back] = uncompressed_array[back], uncompressed_array[front] if front < back
      end
      front += 1
    end
    checksum = 0
    uncompressed_array.each_with_index do |num, index|
      break if num == :blank
      checksum += num * index
    end
    puts checksum

    # PART 2

    next_id -= 1

    (1..block_array.size()-1).to_a.reverse.each do |next_block_id|
      if(block_array[next_block_id].id == next_id)
        next_id -= 1
        target_block = block_array[next_block_id].dup      
        (0..next_block_id).each do |next_blank|
          if(block_array[next_blank].id == :blank && block_array[next_blank].size >= block_array[next_block_id].size)
            block_array[next_blank].size -= block_array[next_block_id].size
            block_array[next_block_id] = Block.new(block_array[next_block_id].size, :blank)
            block_array.insert(next_blank, target_block)
            break
          end
        end

      end
    end
    block_array_serialized = []
    block_array.each do |block|
      block_array_serialized.concat(Array.new(block.size, block.id))
    end

    checksum = 0
    block_array_serialized.each_with_index do |num, index|
      checksum += num * index unless num == :blank
    end
    puts checksum
  end
end