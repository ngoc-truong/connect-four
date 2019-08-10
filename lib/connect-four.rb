class Player 
    @@allowed_signs = ["x", "o"]
    attr_accessor :sign 

    def initialize(sign)
        if @@allowed_signs.include?(sign)
            @sign = sign 
        else 
            @sign = nil 
        end 
    end 

    def choose_column
        allowed = (0..6).to_a
        puts "Please choose a column between 0 and 6!"
        column = gets.chomp

        while !allowed.include?(column.to_i)
            puts "I'm sorry, but you have to choose a column between 1 and 7."
            column = gets.chomp
        end 

        column.to_i
    end
end

class Board 
    attr_accessor :field

    def initialize 
        @field = create
    end

    def create 
        field = []

        6.times do 
            row = []
            7.times do 
                row << "" 
            end
            field << row 
        end

        field
    end

    def print_board
        @field.each do |row| 
            row.each do |cell| 
                if cell == "" 
                    print "[ #{cell}]"
                else 
                    print "[#{cell}]"
                end
            end
            print "\n"
        end
        puts "---------------------"
        puts " 0  1  2  3  4  5  6"
        puts "---------------------"
    end

end 

class Game 
    attr_accessor :player_one, :player_two, :board

    def initialize 
        @player_one = Player.new("x")
        @player_two = Player.new("o")
        @board = Board.new
    end

    def start 
        puts "Welcome to Connect Four! The first player who has four stones in a row wins! Have fun!"

        until win? || board_full?
            one_round 
        end

        puts "Hat er horizontal gewonnen: " + horizontal_win?.to_s
        puts "Hat er vertikal gewonnen: " + vertical_win?.to_s
        puts "Hat er diagonal gewonnen: " + diagonal_win?.to_s
    end

    def one_round 
        puts ""
        @board.print_board 

        puts ""
        puts "It's your turn, Player One ('x')."
        choice = @player_one.choose_column
        update_board(@player_one, choice) 
        @board.print_board 

        if win?
            puts "You win!"
            return 
        end 

        puts ""
        puts "Now, it's your turn, Player Two ('o')."
        choice = @player_two.choose_column
        update_board(@player_two, choice) 
        @board.print_board 
    end

    def update_board(player, column)
        row = 5

        while @board.field[row][column] != "" || row < 0
            row -= 1

            if row == -1
                full_error = "Sorry, this column is full. Choose another one."
                puts full_error  
                return full_error 
            end
        end 

        @board.field[row][column] = player.sign 
    end

    def board_full?
        @board.field.each do |row| 
            if row.include?("")
                return false 
            end
        end 
        true 
    end

    def win? 
        horizontal_win? || vertical_win? || diagonal_win?
    end

    def horizontal_win? 
        counter = 0
        current_symbol = @player_one.sign 

        @board.field.each do |row| 
            row.each do |cell| 
                if cell == current_symbol 
                    counter += 1 
                    return true if counter == 4
                else 
                    counter = 0 
                    current_symbol = @player_two.sign 
                end 
            end
            # Reset counter when going into new row
            counter = 0
        end
        false 
    end

    def vertical_win? 
        counter = 0
        current_symbol = @player_one.sign
        other_symbol = @player_two.sign 
        placeholder = ""  
        row = 0
        column = 0

        while column != 7 
            row = 0
            while row != 6
                if @board.field[row][column] == current_symbol 
                    counter += 1 
                    return true if counter == 4
                else 
                    counter = 1 
                    placeholder = current_symbol
                    current_symbol = other_symbol
                    other_symbol = placeholder 
                end 
                row += 1
            end 
            counter = 0
            column += 1
        end
        false   
    end

    def diagonal_win? 
        diagonals = all_diagonals
        counter = 0
        current_symbol = @player_one.sign 
        other_symbol = @player_two.sign 
        placeholder = "" 

        diagonals.each do |diagonal| 
            diagonal.each do |cell| 
                if @board.field[cell[0]][cell[1]] == current_symbol
                    counter += 1 
                    return true if counter == 4
                else 
                    counter = 1 
                    placeholder = current_symbol
                    current_symbol = other_symbol
                    other_symbol = placeholder
                end
            end 
            counter = 0
        end
        false
    end

    # Helper methods for getting all diagonal combinations
    def all_diagonals 
        all_diagonals_asc + all_diagonals_desc
    end

    def all_diagonals_desc
        all_diagonals = []
        diagonals = []
        x = 0
        y = 0

        4.times do |i| 
            while x < 6 && y < 7 
                diagonals << [x, y]
                x += 1
                y += 1
            end 
            all_diagonals << diagonals
            diagonals = []
            x = 0
            y = i + 1
        end 

        x = 1
        y = 0 

        2.times do |i| 
            while x < 6 && y < 7
                diagonals << [x, y]
                x += 1
                y += 1
            end
            all_diagonals << diagonals 
            diagonals = [] 
            x = i + 2
            y = 0
        end

        all_diagonals 
    end


    def all_diagonals_asc
        all_diagonals = []
        diagonals = []
        x = 0
        y = 3

        4.times do |i| 
            while x < 6 && y > -1
                diagonals << [x, y]
                x += 1
                y -= 1
            end 
            all_diagonals << diagonals
            diagonals = []
            x = 0
            y = i + 4
        end 

        x = 1
        y = 6

        2.times do |i| 
            while x < 6 && y > -1
                diagonals << [x, y]
                x += 1
                y -= 1
            end
            all_diagonals << diagonals 
            diagonals = [] 
            x = i + 2
            y = 6
        end

        all_diagonals 
    end
end

# ToDo: Win-Conditions are not correct yet! REFACTOR!
game = Game.new 
game.start
