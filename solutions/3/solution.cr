class Solution

    def initialize
        @rucksacks = [] of String
        @sum = 0
        @sum2 = 0
    end

    def process
        STDIN.each_line do |line|
            # process input
            @rucksacks.push(line)
        end
    end

    def normalize(let)
        if let.ord >= 97
            let.ord - 96
        else
            let.ord - 64 + 26
        end 
    end

    def part1
        @rucksacks.each do |rucksack|
            top = {} of Char => Int32
            rucksack.chars.each_with_index do |item, index|
                if (index < rucksack.size / 2)
                    top[item] = normalize(item)
                else
                    if top.has_key?(item)
                        @sum += top[item]
                        break
                    end
                end
            end
        end
        puts @sum
    end

    def part2
        all = {} of Char => Int32 
        @rucksacks.each_with_index do |rucksack, index|
            all.clear if index % 3 == 0
            elf = {} of Char => Int32
            rucksack.chars.each do |item|
                if !all.has_key?(item)
                    all[item] = 0
                end
                if !elf.has_key?(item)
                    all[item] += 1
                    elf[item] = normalize(item)
                end
                if all[item] == 3
                    @sum2 += elf[item]
                    break
                end
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
