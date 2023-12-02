sum = 0
last = 0

class Solution
    getter max1
    def initialize
        @max1 = 0
        @max2 = 0
        @max3 = 0
    end

    def setMax(num)
        if num > @max1
            @max3 = @max2
            @max2 = @max1
            @max1 = num
        elsif num > @max2
            @max3 = @max2
            @max2 = num
        elsif num > @max3
            @max3 = num
        end
    end

    def sum
        @max1 + @max2 + @max3
    end
end

solution = Solution.new()

STDIN.each_line do |line|

    sum += line.to_i unless line.chomp == ""

    if line.chomp == ""
        solution.setMax(sum)
        sum = 0
    end
    last = sum
end

# handle edge case by checking last elf
solution.setMax(last)

# first solution
# puts solution.max1

# second solution
puts solution.sum
