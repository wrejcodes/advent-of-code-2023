class Solution

    def initialize
        @seeds = [] of Int64
        @mappings = {
            "seed-to-soil" => [] of Array(Int64),
            "soil-to-fertilizer" => [] of Array(Int64),
            "fertilizer-to-water" => [] of Array(Int64),
            "water-to-light" => [] of Array(Int64),
            "light-to-temperature" => [] of Array(Int64),
            "temperature-to-humidity" => [] of Array(Int64),
            "humidity-to-location" => [] of Array(Int64),
        }
    end

    def get_dest(current_map, key)
        map = @mappings[current_map]
        map.each do |range|
            if key >= range[1] && key < (range[1] + range[2])
                dest = key - range[1] + range[0]
                return dest
            end
        end
        return key
    end

    def get_src(current_map, key)
        map = @mappings[current_map]
        map.each do |range|
            if key >= range[0] && key < (range[0] + range[2])
                src = key - range[0] + range[1]
                return src
            end
        end
        return key
    end

    def process
        current_map = "seed-to-soil"
        seed_re = /seeds: (.*)/
        map_re = /(.*) map:/
        mapping_re  = /[\d\s]+/
        STDIN.each_line do |line|
            # process input
            next if line.chomp == ""
            match_seeds = line.match(seed_re)
            if match_seeds
                match_seeds[1].split(" ").map(&.to_i64).each do |seed|
                    @seeds.push(seed)
                end
                next
            end
            match_map = line.match(map_re)
            if (match_map)
                current_map = match_map[1]
                next
            end
            match_mapping = line.match(mapping_re)
            if (match_mapping)
                dest_start, src_start, range = line.split(" ").map(&.to_i64)
                @mappings[current_map].push([dest_start, src_start, range])
            end
        end
    end

    def part1
        lowest = Int64::MAX
        maps = [
            "seed-to-soil",
            "soil-to-fertilizer",
            "fertilizer-to-water",
            "water-to-light",
            "light-to-temperature",
            "temperature-to-humidity",
            "humidity-to-location"
        ]
        @seeds.each do |seed|
            key = seed
            maps.each do |map|
                key = get_dest(map, key)
            end
            lowest = key if key < lowest
        end
        puts lowest
    end

    def part2
        lowest : Int64 = 0
        maps = [
            "seed-to-soil",
            "soil-to-fertilizer",
            "fertilizer-to-water",
            "water-to-light",
            "light-to-temperature",
            "temperature-to-humidity",
            "humidity-to-location"
        ].reverse
        found = false
        while !found
            key = lowest
            maps.each do |map|
                key = get_src(map, key)
            end
            i = 0
            while i < @seeds.size
                if (key >= @seeds[i] && key < @seeds[i] + @seeds[i + 1])
                    found = true
                    break
                end
                i += 2
            end
            lowest += 1 if !found
        end
        puts lowest
    end

    def run
        process()
        part1()
        part2()
    end

end

Solution.new().run()
