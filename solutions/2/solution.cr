class Solution
    def initialize()
        @game_ids = [] of Int32
        @game_turns = [] of Array(String)
        @redCubes = 12
        @greenCubes = 13
        @blueCubes = 14
        @sum = 0
        @power_sum = 0
    end

    def is_possible(turns : Array(String))
        red_max, blue_max, green_max = 0, 0, 0
        compare_col = pointerof(red_max)
        turns.each do |turn|
            turn.split(",").each do |color_info|
                match = color_info.match(/(\d+) (\w+)/)
                _, num, color = match if match && match.size > 2
                case color
                when "red"
                    compare_col = pointerof(red_max)
                when "blue"
                    compare_col = pointerof(blue_max)
                when "green"
                    compare_col = pointerof(green_max)
                else
                    compare_col = pointerof(red_max)
                end
                num.try { |n| compare_col.value = n.to_i if n.to_i > compare_col.value }
            end
        end
        @power_sum += red_max * blue_max * green_max
        return red_max <= @redCubes &&
            blue_max <= @blueCubes &&
            green_max <= @greenCubes
    end

    def process
        STDIN.each_line do |line|
            # process input
            game_id, gameInfo = line.split(":")
            match = game_id.match(/\D+(\d+)/)
            game_id = match[1] if match
            turns = gameInfo.strip.split(";")
            @game_ids.push(game_id.to_i)
            @game_turns.push(turns)
        end
    end

    def part1
        @game_turns.each_with_index do |turn, inx|
            @sum += @game_ids[inx] if is_possible turn
        end
        puts @sum
    end

    def part2
        puts @power_sum
    end

    def run
        process()
        part1()
        part2()
    end

end

Solution.new().run()
