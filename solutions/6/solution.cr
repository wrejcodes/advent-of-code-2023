class Solution

    def initialize
        @race_times = [] of Int32
        @distances = [] of Int32
    end

    def process
        time_re = /Time:\s+/
        nums = /\d+/
        STDIN.each_line do |line|
            array = line =~ time_re ? @race_times : @distances
            match = line.scan(nums)
            # d is Regex::MatchData hence d[0] to get value
            match.each {|d| array.push d[0].to_i }
        end
    end

    # d = v(t)
    # d = x(race_time - x)
    # d = x*race_time - x^2
    # use derivative to get rate of change
    # d' = race_time - 2x
    # max is when rate of change is 0
    # 0 = race_time - 2x
    # -race_time = -2x
    # x = -race_time / -2
    def get_max_x(race_time)
        race_time // 2
    end

    # d = x(race_time - x)
    def get_dist(race_time, x)
        x * (race_time - x)
    end

    def walk_max(race_time, dist_to_check)
        max_x = get_max_x race_time
        # include found max in count
        count = 1
        #walk left
        current = max_x - 1
        while (get_dist(race_time, current) > dist_to_check)
            current -= 1
            count += 1
        end
        #walk right
        current = max_x + 1
        while (get_dist(race_time, current) > dist_to_check)
            current += 1
            count += 1
        end
        count
    end

    def part1
        answer = 1
        @race_times.each_with_index do |race_time, index|
            answer *= walk_max(race_time, @distances[index])
        end
        puts answer
    end

    def part2
        race_time = @race_times.map(&.to_s).join().to_i64
        distance = @distances.map(&.to_s).join().to_i64
        puts walk_max(race_time, distance)
    end

    def run
        process()
        part1()
        part2()
    end

end

Solution.new().run()
