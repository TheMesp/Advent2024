def equation_possible(nums,index,target,curr_sum,allow_concat)
  if(index == nums.size() - 1)
    return curr_sum == target
  end
  next_num = nums[index + 1].to_i
  output = false
  if(curr_sum * next_num <= target)
    output = equation_possible(nums,index + 1,target,curr_sum * next_num,allow_concat)
  end
  if(!output && curr_sum + next_num <= target)
    output = equation_possible(nums,index + 1,target,curr_sum + next_num,allow_concat)
  end
  if(allow_concat && !output && (curr_sum.to_s + next_num.to_s).to_i <= target)
    output = equation_possible(nums,index + 1,target,(curr_sum.to_s + next_num.to_s).to_i,allow_concat)
  end
  return output
end

File.open("inputs/day7.input", "r") do |f|
  p1sum = 0
  p2sum = 0
  f.each_line do |line|
    nums = line.split(" ")
    target = nums.shift.to_i
    p1sum += target if equation_possible(nums, 0, target, nums[0].to_i, false)
    p2sum += target if equation_possible(nums, 0, target, nums[0].to_i, true)
  end
  puts p1sum
  puts p2sum
end
