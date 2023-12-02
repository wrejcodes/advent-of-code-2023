class Solution

    def initialize
        @viz = {} of Int32 => Bool
        @side_size = 0
        @grid = [] of Int32
        @max = 0
    end

    def process
        STDIN.each_line do |line|
            # process input
            @side_size = line.chomp.size if @side_size == 0
            line.chars.each {|tree| @grid << tree.to_i}
        end
    end

    def is_edge(index)
        return true if index < @side_size
        return true if index % @side_size == 0
        return true if index % @side_size == @side_size - 1
        return true if index >= (@side_size - 1) * @side_size
        false
    end

    def walk_trees(index)
        pos = index
        tree = @grid[index]
        up, left, right, down = [true, true, true, true]
        up_count, left_count, right_count, down_count = [1,1,1,1]

        #edges 
        top_edge = 0
        left_edge = (index / @side_size).to_i * @side_size
        right_edge = (index / @side_size).to_i * @side_size + @side_size - 1
        bottom_edge = @side_size * @side_size

        # up
        loop do
            pos -= @side_size
            if @grid[pos] >= tree
                up = false
                break
            end
            break if pos - @side_size < top_edge
            up_count += 1
        end
        #left
        pos = index
        loop do
            pos -= 1
            if @grid[pos] >= tree
                left = false
                break
            end
            break if pos - 1 < left_edge
            left_count += 1
        end
        #right
        pos = index
        loop do
            pos += 1
            if @grid[pos] >= tree
                right = false
                break
            end
            break if pos + 1 > right_edge
            right_count += 1
        end
        #down
        pos = index
        loop do
            pos += @side_size
            if @grid[pos] >= tree
                down = false
                break
            end
            break if pos + @side_size > bottom_edge
            down_count += 1
        end
        scenic_score = up_count * left_count * right_count * down_count
        is_viz = up || left || right || down ? 1 : 0
        return [is_viz, scenic_score]
    end

    def evaluate_trees()
        @grid.each_with_index do |tree, index|
            if is_edge index
                @viz[index] = true
                # assuming that edge will not have highest scenic score
                next
            else
                viz, score = walk_trees index
                @viz[index] = true if viz == 1
                @max = score if score > @max
            end
        end
    end

    def part1
        puts @viz.size
    end

    def part2
        puts @max
    end

    def run
        process()
        evaluate_trees()
        part1()
        part2()
    end

end

Solution.new().run()
