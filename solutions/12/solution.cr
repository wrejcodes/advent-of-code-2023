class Node
    property x : Int32
    property y : Int32
    def initialize(@x, @y)
    end

    def ==(other : Node)
        @x == other.x && @y == other.y
    end

    def clone
        Node.new(@x, @y)
    end

    def to_s
        "<#{@x},#{y}>"
    end
end

EMPTY_NODE = Node.new(-1,-1)

class Search
    @open : Array(SearchPath)
    def initialize(@graph : Array(Array(Char)), @start : Node, @end : Node)
        start_path = SearchPath.new()
        start_path.add_node(@start)
        @open = [start_path]
        @closed = [] of Node
    end

    def search
        path = SearchPath.new()
        loop do
            path = get_lowest_f
            @closed << path.current
            break if path.current == @end
            expand(path)
            if @open.size == 0
                path = NonViableSearchPath.new()
                break
            end
        end
        path
    end

    def short_search
        test_path = SearchPath.new().add_node(@start)
        next_nodes = possible_nodes(test_path)
        one_step_from_b = false
        next_nodes.each do |node|
            one_step_from_b = true if @graph[node.y][node.x] == 'b'
        end
        return NonViableSearchPath.new() unless one_step_from_b
        search
    end

    def possible_nodes(path)
        node = path.current
        up = Node.new(node.x, node.y - 1)
        right = Node.new(node.x + 1, node.y)
        left = Node.new(node.x - 1, node.y)
        down = Node.new(node.x, node.y + 1)
        new_nodes = [up, right, left, down]
        new_nodes.select do |new_node|
            node_valid = valid(new_node, node)
            node_not_visited = !@closed.includes?(new_node)
            node_valid && node_not_visited
        end
    end

    def expand(path : SearchPath)
        new_nodes = possible_nodes(path)
        new_paths = new_nodes.map { |new_node| SearchPath.new(path).add_node(new_node) }
        new_paths.each do |new_path|
            if @open.includes?(new_path)
                path_inx = @open.index! {|o_path| o_path == new_path}
                @open[path_inx] = @open[path_inx].cheaper_path(new_path)
                next
            end
            @open << new_path
        end
    end

    def valid(node : Node, current : Node)
        return false if node.x < 0 || node.y < 0
        return false if node.x > @graph[0].size - 1 || node.y > @graph.size - 1
        node_elevation = @graph[node.y][node.x]
        current_elevation = @graph[current.y][current.x]
        node_elevation = normalize(node_elevation)
        current_elevation = normalize(current_elevation)
        node_elevation.ord - current_elevation.ord <= 1
    end

    def normalize(elevation)
        return 'a' if elevation == 'S'
        return 'z' if elevation == 'E'
        elevation
    end

    def get_lowest_f
        lowest = Int32::MAX
        lowest_path = SearchPath.new()
        lowest_i = @open.size
        @open.each_with_index do |path, index|
            f = est(path)
            if (f < lowest)
                lowest_path = path
                lowest = f
                lowest_i = index
            end
        end
        @open.delete_at(lowest_i)
    end

    def est(path : SearchPath)
        path.cost + distance(path.current, @end)
    end

    def distance(node1 : Node, node2 : Node)
        (node1.x - node2.x).abs + (node1.y - node2.y).abs
    end
end

class SearchPath
    property nodes = [] of Node
    property cost = 0
    property current : Node
    def initialize(other : SearchPath)
        @nodes = other.nodes.clone
        @cost = other.cost
        @current = other.nodes.last
    end
    def initialize
        @current = EMPTY_NODE
    end

    def == (other : SearchPath)
        same_spot(other)
    end

    def same_spot(other : SearchPath)
        other.current == @current
    end

    def cheaper_path(other : SearchPath)
        other.cost < @cost ? other : self
    end

    def add_node(node : Node)
        @cost += 1 unless @nodes.size == 0
        @nodes << node
        @current = node
        self
    end

    def to_s
        "cost: #{cost} -> current: #{current.to_s}"
    end

    def clone
        SearchPath.new(self)
    end
end

class NonViableSearchPath < SearchPath
    property cost = Int32::MAX
end

class Solution
    def initialize
        @graph = [] of Array(Char)
        @row = 0
        @start = Node.new(0,0)
        @end = Node.new(0,0)
    end

    def process
        STDIN.each_line do |line|
            # process input
            split = line.chars
            split.each_with_index do |letter, index|
                if letter == 'S'
                    @start = Node.new(index, @row)
                end
                if letter == 'E'
                    @end = Node.new(index, @row)
                end
            end
            @graph << split
            @row += 1
        end
    end

    def part1
        path = Search.new(@graph, @start, @end).search
        puts path.cost
    end

    def part2
        shortest = Int32::MAX
        @graph.each_with_index do |row, row_index|
            row.each_with_index do |letter, col_index|
                if letter == 'S'|| letter == 'a'
                    steps = Search.new(@graph, Node.new(col_index, row_index), @end).short_search.cost
                    shortest = steps if steps < shortest
                end
            end
        end
        puts shortest
    end

    def run
        process()
        part1()
        part2()
    end

end

Solution.new().run()
