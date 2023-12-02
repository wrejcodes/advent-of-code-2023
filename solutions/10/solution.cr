class Solution

    def initialize
        @instructions = [] of String
        @cycles = 240
        @x = 1
        @sum = 0
        @crt = [] of Array(Char)
    end

    def process
        STDIN.each_line do |line|
            # process input
            @instructions << line
        end
    end

    def cycles()
        ins_stack = [] of String
        ins_ptr = 0
        @cycles.times do |cycle|
            crt_cycle = cycle % 40
            crt_row = (cycle / 40).to_i
            normalized_cycle = cycle + 1

            #new row
            @crt << [] of Char if crt_cycle == 0

            #calc sig strength
            if normalized_cycle % 40 == 20
                @sum += (@x * normalized_cycle)
            end

            #draw
            @crt[crt_row] << ((crt_cycle - @x).abs <= 1 ? '#' : '.')

            #read instruction
            if ins_stack.empty?
                if ins_ptr < @instructions.size - 1
                    ins = @instructions[ins_ptr]
                    ins_stack << ins
                    ins_stack << "noop" if ins =~ /^addx/
                end
                ins_ptr += 1
            end

            # run instruction stack
            if ins_stack.size > 0
                ins = ins_stack.pop()
                if match = ins.match(/^addx (.*)/)
                    @x += match[1].to_i
                end
            end
        end
    end

    def part1
        puts @sum
    end

    def part2
        @crt.each do |row|
            puts row.join()
        end
    end

    def run
        process()
        cycles()
        part1()
        part2()
    end

end

Solution.new().run()
