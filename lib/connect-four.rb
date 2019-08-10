class Player 
    @@allowed_colors = ["yellow", "red"]
    attr_accessor :color 

    def initialize(color)
        if @@allowed_colors.include?(color)
            @color = color 
        else 
            @color = nil 
        end 
    end 

    def choose_column
        allowed = (1..7).to_a
        puts "Please choose a column between 1 and 7!"
        column = gets.chomp

        while !allowed.include?(column.to_i)
            puts "I'm sorry, but you have to choose a column between 1 and 7."
            column = gets.chomp
        end 

        column.to_i
    end
end

class Board 
    attr_accessor :board

    def initialize 
        @board = create_board
    end

    def create_board 
        board = []

        6.times do 
            row = []
            7.times do 
                row << "" 
            end
            board << row 
        end

        board
    end

    def print_board 
        @board.each do |row| 
            row.each do |cell| 
                if cell == "" 
                    print "[ #{cell}]"
                else 
                    print "[#{cell}]"
                end
            end
            print "\n"
        end
    end
end 

class Game 
    attr_accessor :player_one, :player_two, :board

    def initialize 
        @player_one = Player.new("yellow")
        @player_two = Player.new("red")
        @board = Board.new
    end
end