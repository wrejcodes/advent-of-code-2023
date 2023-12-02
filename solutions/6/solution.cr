class Solution

    def initialize
        @signal = ""
    end

    def process
        STDIN.each_line do |line|
            @signal = line
        end
    end

    def eachDifferent(start, last_pos)
        letters = {} of Char => Bool
        (start..last_pos).to_a.each do |i|
            if !letters.has_key?(@signal[i])
                letters[@signal[i]] = true
            else
                return false
            end
        end
        true
    end

    def sub_routine(length)
        last_pos = length - 1
        marker = last_pos
        start = 0
        loop do 
            if eachDifferent(start, last_pos)
                marker = last_pos
                break
            end
            start += 1
            last_pos += 1
        end
        marker + 1
    end

    def part1
        puts sub_routine 4
    end

    def part2
        puts sub_routine 14
    end

    def run
        process()
        part1()
        part2()
    end

end

Solution.new().run()
