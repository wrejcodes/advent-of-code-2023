class Solution

    @sum : Int32

    def initialize(@sum = 0)
        @number_words = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    end

    def word_to_num(str)
        re = /\d/
        if str =~ re
            return str.to_i
        else
            inx = @number_words.index { |word| str == word }
            return inx ? inx + 1 : 0
        end
    end

    def process
        re = /(one|two|three|four|five|six|seven|eight|nine|\d)/
        STDIN.each_line do |line|
            # process input
            nums = [] of Int32
            i = 0
            while i < line.size
                match = line.match(re, i)
                if match && match.size > 1
                    nums.push(wordToNum(match[1]))
                    inx = line.index(re, i)
                    i = inx + match[1].size if inx
                    i -= 1 if match[1].size > 1
                else
                    break
                end
            end
            @sum += nums.first * 10 + nums.last
        end
        puts @sum
    end

    def run
        process()
    end

end

Solution.new().run()
