class Solution

    def initialize
        @stacks = [] of Array(Char)
        @instructions = [] of Array(Int32)
    end

    def process
        instructions = false
        STDIN.each_line do |line|
            # process input
            if line =~ /^[\d\s]+$/
                instructions = true
                next
            end
            next if line.chomp == ""
            if instructions
                #process instructions
                instruction_set = [] of Int32
                if match = line.match(/move (.*) from (.*) to (.*)/)
                    instruction_set << match[1].to_i
                    instruction_set << match[2].to_i
                    instruction_set << match[3].to_i
                end
                @instructions << instruction_set
            else
                #process crates
                crates = line.size / 4 + 1
                crates.to_i.times {@stacks << [] of Char} if @stacks.empty?
                crates.to_i.times do |i|
                    @stacks[i] << line[i * 4 + 1] if line[i * 4 + 1] != ' '
                end
            end
        end
        @stacks.each(&.reverse!)
    end

    def part1
        stack_copy = @stacks.clone
        @instructions.each do |instruction_set|
            instruction_set[0].times { stack_copy[instruction_set[2] - 1] << stack_copy[instruction_set[1] - 1].pop() }
        end
        puts stack_copy.map(&.pop).join()
    end

    def part2
        stack_copy = @stacks.clone
        @instructions.each do |instruction_set|
            crates_to_move = stack_copy[instruction_set[1] -1].pop(instruction_set[0])
            crates_to_move.each { |crate| stack_copy[instruction_set[2] -1] << crate }
        end
        puts stack_copy.map(&.pop).join()
    end

    def run
        process()
        part1()
        part2()
    end

end

Solution.new().run()
