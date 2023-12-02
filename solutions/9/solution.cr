DEBUG = ENV.has_key?("AOC_DEBUG")
class Knot
    @touched : Set(Array(Int32))
    getter touched
    getter pos
    getter name
    getter head
    def initialize(head : Knot, name : String)
        @head = head
        @pos = @head.not_nil!.pos.clone
        @touched = Set.new([@pos.clone])
        @name = name
    end

    def initialize(pos : Array(Int32), name : String)
        @head = nil
        @pos = pos.clone
        @touched = Set.new([@pos.clone])
        @name = name
    end

    def touching()
        head = @head.not_nil!
        return Math.isqrt((head.pos[0] - @pos[0]) ** 2 + (head.pos[1] - @pos[1]) ** 2) <= 1
    end

    def catch_up
        head = @head.not_nil!
        diff = [head.pos[0] - @pos[0], head.pos[1] - @pos[1]]
        diff[0] = (diff[0] / 2).to_i if diff[0].abs > 1
        diff[1] = (diff[1] / 2).to_i if diff[1].abs > 1
        @pos[0] += diff[0]
        @pos[1] += diff[1]
    end

    def move(dir)
        if @head.nil?
            move_head dir 
        else 
            head = @head.not_nil!
            head.move(dir)
            move_knot
        end
        @touched.add @pos.clone
    end

    def move_head(dir)
        case dir
        when "U"
            @pos[1] += 1
        when "R"
            @pos[0] += 1
        when "L"
            @pos[0] -= 1
        when "D"
            @pos[1] -= 1
        else
            raise "Invalid Move!"
        end
    end

    def move_knot
        catch_up if !touching
    end
end

class Solution
    def initialize
        @moves = [] of String
        @root = nil
        @min_x = 0
        @max_x = 0
        @min_y = 0
        @max_y = 0
        @head_pos = [0,0]
        @padding = 2
    end

    def process
        STDIN.each_line do |line|
            # process input
            @moves << line
            track_min_max_x_y(line) if DEBUG
        end
    end

    def track_min_max_x_y(line)
        dir, steps = line.split(' ')
        num = steps.to_i
        case dir
        when "U"
            @head_pos[1] += num
        when "R"
            @head_pos[0] += num
        when "L"
            @head_pos[0] -= num
        when "D"
            @head_pos[1] -= num
        else
            raise "Invalid Move!"
        end
        @max_x = @head_pos[0] if @head_pos[0] > @max_x
        @max_y = @head_pos[1] if @head_pos[1] > @max_y
        @min_y = @head_pos[1] if @head_pos[1] < @min_y
        @min_x = @head_pos[0] if @head_pos[0] < @min_x
    end

    def plot()
        points = {} of String => Char
        start = @root
        loop do 
            if start.nil?
                break
            end
            node = start.not_nil!
            point = node.pos.map(&.to_s).join(",")
            points[point] = node.name.chars[0]
            start = node.head
        end
        lines = [] of String
        y_range = (@min_y - @padding) .. (@max_y + @padding)
        x_range = (@min_x - @padding) .. (@max_x + @padding)
        (y_range).each do |i|
            line = [] of Char
            (x_range).each do |j|
                key = [j, i].map(&.to_s).join(",")
                if points.has_key? key
                    line << points[key]
                else
                    line << '.'
                end
            end
            lines << line.join()
        end
        lines.size.times {STDERR.puts lines.pop}
    end

    def plot_tail_path()
        lines = [] of String
        root = @root.not_nil!
        y_range = (@min_y - @padding) .. (@max_y + @padding)
        x_range = (@min_x - @padding) .. (@max_x + @padding)
        (y_range).each do |i|
            line = [] of Char
            (x_range).each do |j|
                if i == 0 && j == 0
                    line << 's'
                elsif root.touched.includes?([j, i])
                    line << '#'
                else
                    line << '.'
                end
            end
            lines << line.join()
        end
        lines.size.times {STDERR.puts lines.pop}
        STDERR.puts "Tail Path"
        STDERR.puts "Note: extra padding of #{@padding} added to each side of each plot"
        STDERR.puts ""
    end

    def move_knots(knot_size)
        should_debug = DEBUG && knot_size > 2
        knot_size.times do |i|
            if i == 0
                @root = Knot.new([0, 0], "H")
            else
                root = @root.not_nil!
                @root = Knot.new(root, i.to_s)
            end
        end
        @moves.each do |move|
            dir, steps = move.split(' ')
            if should_debug
                STDERR.puts ""
                STDERR.puts("======#{dir} #{steps}=======")
            end
            steps = steps.to_i
            steps.times do | i |
                root = @root.not_nil!
                root.move(dir)
                # technically works for test input but I couldn't make
                # my terminal large enough to truly see the output
                if should_debug
                    plot()
                    STDERR.puts "#{dir}:#{i + 1}"
                    STDERR.puts ""
                end
            end
        end
        plot_tail_path() if should_debug
        root = @root.not_nil!
        return root.touched.size
    end

    def part1
        puts move_knots 2
    end

    def part2
        puts move_knots 10 # I spent about 1.5 hrs with this at 9 :rip:
    end

    def run
        process()
        part1()
        part2()
    end

end

Solution.new().run()
