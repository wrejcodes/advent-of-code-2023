class Solution
    ROCK = 1
    PAPER = 2
    SCISSORS = 3

    LOSE = 0
    DRAW = 3
    WIN = 6

    def initialize
        @total = 0
        @rounds = [] of Array(String)
    end

    def normalize(round)
        [round[0][0].ord - 64, round[1][0].ord - 64 - 23]
    end

    def normalizeRigged(round)
        [round[0][0].ord - 64, 3 * (round[1][0].ord - 64 - 24)]
    end

    def outcomeRigged(opp, rigged)
        if rigged == WIN
            opp == SCISSORS ? ROCK + rigged : opp + 1 + rigged 
        elsif rigged == LOSE
            opp == ROCK ? rigged + SCISSORS : opp - 1 + rigged
        else
            DRAW + opp
        end
    end

    def outcome(opp, you)
        if opp == ROCK && you == SCISSORS
            LOSE + you
        elsif you == ROCK && opp == SCISSORS
            WIN + you
        elsif you > opp
            WIN + you
        elsif opp > you
            LOSE + you
        else
            DRAW + you
        end
    end

    def process
        STDIN.each_line do |line|
            # process input
            @rounds.push(line.split(' '))
        end
    end

    def part1
        @rounds.each do |round|
            opp, you = normalize(round)
            @total += outcome(opp, you)
        end
        puts @total
    end

    def part2
        @total = 0
        @rounds.each do |round|
            opp, you = normalizeRigged(round)
            @total += outcomeRigged(opp, you)
        end
        puts @total
    end

    def run
        process()
        part1()
        part2()
    end
end

solution = Solution.new()
solution.run()
