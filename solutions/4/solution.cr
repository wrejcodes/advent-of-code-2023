class Solution

    def initialize
        @cards = [] of Array(Array(Int32))
        @sum = 0
    end

    def process
        STDIN.each_line do |line|
            smooshed = line.gsub(/\s+/, " ")
            parts = smooshed.split(":")
            winning, losing = parts[1].split("|")
            @cards.push([winning.strip.split(" ").map(&.to_i), losing.strip.split(" ").map(&.to_i)])
        end
    end

    def part1
        @cards.each do |card|
            points = 0
            winning_nums = {} of Int32 => Bool
            winning, losing = card
            winning.each do |num|
                winning_nums[num] = true
            end

            losing.each do |num|
                if winning_nums.has_key? num
                    points = points == 0 ? 1 : points * 2
                end
            end
            @sum += points
        end
        puts @sum
    end

    def part2
        @sum = 0
        indices = {} of Int32 => Int32
        @cards.each_with_index do |card, index|
            points = 0
            winning_nums = {} of Int32 => Bool
            winning, losing = card
            winning.each do |num|
                winning_nums[num] = true
            end

            losing.each do |num|
                if winning_nums.has_key? num
                    points += 1
                end
            end

            # keep track of how many copies of this card you have
            num_dupes = indices.has_key?(index) ? indices[index] + 1 : 1

            points.times do |x|
                indices[x + index + 1] = 0 unless indices.has_key?(x + index + 1)
                # save the copies of the next card
                # (for each copy of the current card that you have made)
                indices[x + index + 1] += 1 * num_dupes
            end
            if indices.has_key?(index)
                # add the copies
                @sum += 1 * indices[index]
            end
            # add the original
            @sum += 1
        end
        puts @sum
    end

    def run
        process()
        part1()
        part2()
    end

end

Solution.new().run()
