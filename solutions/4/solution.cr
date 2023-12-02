class Elf
    getter start : Int32
    getter last : Int32
    def initialize(elf)
        @start = elf[0].to_i
        @last = elf[1].to_i
    end

    def swallow?(other : Elf)
        @start <= other.start && @last >= other.last
    end

    def include?(other : Elf)
        other.start <= last && other.start >= @start
    end
end

class Solution

    def initialize
        @pairs = [] of Array(Elf)
        @sum = 0
        @sum2 = 0
    end

    def process
        STDIN.each_line do |line|
            # process input
            @pairs << line.split(',').map { |elf| Elf.new(elf.split('-')) }
        end
    end

    def part1
        @pairs.each do |pair| 
            elf1, elf2 = pair
            if elf1.swallow?(elf2) || elf2.swallow?(elf1)
                @sum +=1
            end
        end
        puts @sum
    end

    def part2
        @pairs.each do |pair|
            elf1, elf2 = pair
            if elf1.include?(elf2) || elf2.include?(elf1)
                @sum2 += 1
            end
        end
        puts @sum2
    end

    def run
        process()
        part1()
        part2()
    end

end

Solution.new().run()
