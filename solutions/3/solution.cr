class Solution

    def initialize
        @schematic = [] of Array(String)
        # key track of visited nodes, note if sym or not and position of gears
        #                              is_sym    x     y    symbol
        @walked = {} of String => Tuple(Bool, Int32, Int32, String)
        @col_upper_bound = 0
        @row_upper_bound = 0
        @parts = [] of Int32
        @potential_gears = {} of String => Array(Int32)
        @sum = 0
        @num_chars = [] of String
        @is_part = false
        @is_potential_gear = false
        @gear_pos = [-1, -1]
    end

    def in_bounds(i, j)
        i >= 0 && i <= @row_upper_bound && j >= 0 && j <= @col_upper_bound
    end

    def get_key(i,j)
        "#{i}:#{j}"
    end

    def clean_state
        # clean up look up refs while we process data
        @is_potential_gear = false
        @gear_pos = [-1, -1]
        @is_part = false
        @num_chars.clear
    end

    def adjacent_to_sym(i, j)
        sym_re = /[^\d.]/
        up_left = [i - 1, j - 1]
        up = [i - 1, j]
        up_right = [i - 1, j + 1]
        left = [i, j - 1]
        right = [i, j + 1]
        down_left = [i + 1, j - 1]
        down = [i + 1, j]
        down_right = [i + 1, j + 1]
        directions_to_check = [up_left, up, up_right, left, right, down_left, down, down_right]
        directions_to_check.each do |dir|
            key = get_key(dir[0], dir[1])
            if @walked.has_key?(key)
                # exit early if we've found before and it is a sym
                return @walked[key] if @walked[key][0]
                # check next direction if not sym
                next
            end
            if in_bounds(dir[0], dir[1])
                is_sym = @schematic[dir[0]][dir[1]].match(sym_re)
                @walked[key] = { is_sym ? true : false, dir[0], dir[1], @schematic[dir[0]][dir[1]] }
                return @walked[key] if is_sym
            end
        end
        return { false, -1, -1, "" }
    end

    def find_parts
        num_re = /\d/
        not_num_re = /\D/
        @schematic.each_with_index do |row, i|
            row.each_with_index do |letter, j|
                @num_chars.push(letter) if letter =~ num_re

                # get adjaceny information
                adj_info = adjacent_to_sym(i, j)
                if adj_info[0] && @num_chars.size > 0
                    @is_part = true
                    @is_potential_gear = adj_info[3] == "*"
                    @gear_pos = [adj_info[1], adj_info[2]] if @is_potential_gear
                end

                # if end of number or end of line
                if (j == @col_upper_bound || @schematic[i][j + 1] =~ not_num_re) && @num_chars.size > 0
                    # process current number and track potential gears
                    num = @num_chars.join().to_i
                    @sum += num if @is_part
                    # we don't really need this but it was useful while debugging
                    @parts.push(num) if @is_part
                    # track potential gears
                    if @is_potential_gear
                        gear_key = get_key(@gear_pos[0], @gear_pos[1])
                        if !@potential_gears.has_key?(gear_key)
                            @potential_gears[gear_key] = [] of Int32
                        end
                        @potential_gears[gear_key].push(num)
                    end
                    # clean up temp variables for next part of loop
                    clean_state
                end
            end
        end
    end

    def process
        STDIN.each_line do |line|
            # process input
            @schematic.push(line.split(""))
        end
        # keep track of bounds
        @col_upper_bound = @schematic[0].size - 1
        @row_upper_bound = @schematic.size - 1
    end

    def part1
        find_parts
        puts @sum
    end

    def part2
        @sum = 0
        @potential_gears.each do |key, value|
            if value.size == 2
                @sum += value[0] * value[1]
            end
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
