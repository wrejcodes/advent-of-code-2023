class Solution

    def initialize
        @cwd = Path.new("")
        @dirs = {} of String => Int32
        @sum = 0
    end

    def parse_command(match)
        return if match[1] == "ls"
        if match[2] == ".."
            @cwd = @cwd.parent
        else
            @cwd /= match[2]
        end
    end

    def parse_output(line)
        return if line =~ /^dir/
        if match = line.match(/^(\d+) .*/)
            size = match[1]
            temp_path = Path.new("")
            @cwd.each_part do |dir|
                temp_path /= dir
                @dirs[temp_path.to_s] = 0 if !@dirs.has_key?(temp_path.to_s)
                @dirs[temp_path.to_s] += size.to_i
            end
        end
    end

    def process
        STDIN.each_line do |line|
            # process input
            if match = line.match(/^\$ (\w+) (\w+|\/|\.+)/)
                parse_command match
            else
                parse_output line
            end
        end
    end

    def part1
        @dirs.each do |dir, size|
            @sum += size if size <= 100000
        end
        puts @sum
    end

    def part2
        total = @dirs["/"]
        target = 30000000
        max = 70000000
        potential_dirs = [] of Int32
        @dirs.each do |dir, size|
            if total + target - size <= max
                potential_dirs << size
            end
        end
        puts potential_dirs.sort()[0]
    end

    def run
        process()
        part1()
        part2()
    end

end

Solution.new().run()
