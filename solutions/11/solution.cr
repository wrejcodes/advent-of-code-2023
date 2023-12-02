class MonkeyBusiness
    def initialize(rounds : Int32, use_reducer : Bool)
        @rounds = rounds
        @monkeys = [] of Monkey
        @use_reducer = use_reducer
    end

    def add_monkey(monkey : Monkey)
        @monkeys.push(monkey)
    end

    def gcd(a : Int64, b : Int64)
        return b if a == 0
        return gcd(b % a, a)
    end

    def lcm(a : Int64, b : Int64)
        (a * b / gcd(a,b)).to_i64
    end

    def find_modifier
        divs = [] of Int64
        @monkeys.each do |monkey|
            divs << monkey.test[0].to_i64
        end
        result = divs.pop()
        divs.each do |div|
            result = lcm(div, result)
        end
        return result
    end

    def commence_monkey_business
        reducer = 0.to_i64
        reducer = find_modifier if @use_reducer
        rounds_before_repeat = 0
        @rounds.times do |round|
            @monkeys.each do |monkey|
                loop do
                    break if monkey.size < 1
                    to_monkey, item = monkey.monkey_around(reducer)
                    @monkeys[to_monkey].grab(item)
                end
            end
        end
    end

    def monkey_business_score
        max1, max2 = 0, 0
        @monkeys.each do |monkey|
            if monkey.inspections > max1
                max2 = max1
                max1 = monkey.inspections
            elsif monkey.inspections > max2
                max2 = monkey.inspections
            end
        end
        max1.to_i64 * max2.to_i64
    end
end

class Monkey
    getter inspections
    getter test
    def initialize(
            items : Array(Int64),
            operation : Array(String),
            test : Array(Int32)
        )
        @items = items
        @operation = operation
        @test = test
        @inspections = 0
    end

    def inspect(item)
        @inspections += 1
        operation_num = 0
        if @operation[1] == "old"
            operation_num = item
        else
            operation_num = @operation[1].to_i64
        end
        case @operation[0]
        when "*"
            return item * operation_num
        when "+"
            return item + operation_num
        else
            raise "Invalid operation"
        end
    end

    def test_item(item)
        if item % @test[0] == 0
            return @test[1], item
        else
            return @test[2], item
        end 
    end

    def monkey_around(reducer : Int64 = 0)
        item = @items.shift
        item = inspect(item)
        if reducer == 0
            item = (item / 3).to_i64
        else
            item %= reducer
        end
        # returns [monkey, item]
        return test_item(item)
    end

    def grab(item)
        @items.push(item)
    end

    def size
        return @items.size
    end
end

class Solution

    def initialize
        @monkey_business = MonkeyBusiness.new(20, false)
        @monkey_business2 = MonkeyBusiness.new(10000, true)
    end

    def process
        items = [] of Int64
        operation = [] of String
        test = [] of Int32
        STDIN.each_line do |line|
            # process input
            next if line == ""
            next if line =~ /Monkey \d+:/

            if match = line.lstrip.match(/Starting .*: (.*)/)
                items = match[1].not_nil!.split(", ").map(&.to_i64)
            end

            if match = line.lstrip.match(/Operation: .* old (.) (.+)/)
                operation << match[1].not_nil!
                operation << match[2].not_nil!
            end

            if match = line.lstrip.match(/Test: .* (\d+)/)
                test << match[1].not_nil!.to_i
            end

            if match = line.lstrip.match(/If true: .* (\d+)/)
                test << match[1].not_nil!.to_i
            end

            if match = line.lstrip.match(/If false: .* (\d+)/)
                test << match[1].not_nil!.to_i
                @monkey_business.add_monkey(
                    Monkey.new(items.clone, operation.clone, test.clone)
                )
                @monkey_business2.add_monkey(
                    Monkey.new(items.clone, operation.clone, test.clone)
                )
                [items, operation, test].each(&.clear)
            end
        end
    end

    def simians_sling_stuff()
        @monkey_business.commence_monkey_business
        @monkey_business2.commence_monkey_business
    end

    def part1
        puts @monkey_business.monkey_business_score
    end

    def part2
        puts @monkey_business2.monkey_business_score
    end

    def run
        process()
        simians_sling_stuff()
        part1()
        part2()
    end

end

Solution.new().run()
