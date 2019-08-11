require "./lib/connect-four"

describe Player do 
    before { @player = Player.new("#{sign}") } 

    context "Player has sign x" do 
        let(:sign) { "x" }

        it "has x symbol" do 
            expect(@player.sign).to eq("x")
        end
    end 

    context "Initiating player with wrong sign" do 
        let(:sign) { "green" }

        it "does not set the sign to green but nil" do 
            expect(@player.sign).to eq(nil)
        end
    end 

    context "Player can choose a number." do 
        let(:sign) { "x" }

        it "chooses a correct number" do 
            expect(@player.choose_column).to be_between(0, 6)
        end 
    end
end 

describe Board do 
    before { @board = Board.new }

    context "Creating the board" do 
        it "creates a board in a two dimensional array" do 
            expect(@board.create).to eq( [    ["", "", "", "", "", "", ""],
                                                    ["", "", "", "", "", "", ""], 
                                                    ["", "", "", "", "", "", ""],
                                                    ["", "", "", "", "", "", ""],
                                                    ["", "", "", "", "", "", ""],
                                                    ["", "", "", "", "", "", ""]])
        end
    end 
end 

describe Game do 
    before { @game = Game.new }

    context "Game has all correct attributes" do 
        it "has two players" do 
            expect(@game.player_one).to be_a(Player) 
            expect(@game.player_two).to be_a(Player) 
        end

        it "has a board" do 
            expect(@game.board).to be_a Board
        end
    end 

    context "Game mechanics" do 
        it "changes board when player one chooses column 3 in an empty field" do 
            @game.update_board(@game.player_one, 3)
            expect(@game.board.field[5][3]).to eql(@game.player_one.sign)
        end 

        it "gives an error if all fields in a column are full" do 
            6.times do |num| 
                @game.board.field[num][3] = "x"
            end

            expect(@game.column_full?(3)).to eql(true)
        end

        it "indicates when a board is not full" do 
            expect(@game.board_full?).to eq(false)
        end

        it "indicates when a board is full" do 
            6.times do |row| 
                7.times do |cell| 
                    if cell % 2 == 0
                        @game.board.field[row][cell] = @game.player_one.sign 
                    else 
                        @game.board.field[row][cell] = @game.player_two.sign 
                    end 
                end 
            end

            expect(@game.board_full?).to eq(true)
        end

        it "indicates that a player wins with 4 stones in a row" do 
            4.times do |cell| 
                @game.board.field[0][cell] = @game.player_one.sign 
            end 

            expect(@game.horizontal_win?).to eq(true)
        end 

        it "indicates that a player does not win with three stones" do 
            3.times do |cell| 
                @game.board.field[0][cell] = @game.player_one.sign 
            end 

            expect(@game.horizontal_win?).to eq(false)
        end 

        it "indicates that player does not win when the fourth stone is in a new row" do 
            3.times do |cell| 
                @game.board.field[1][cell] = @game.player_one.sign 
            end 

            @game.board.field[0][6] = @game.player_one.sign 

            expect(@game.horizontal_win?).to eq(false)
        end


        it "indicates when a player wins vertically" do 
            4.times do |cell| 
                @game.board.field[cell][3] = @game.player_one.sign 
            end 

            expect(@game.vertical_win?).to eq(true)
        end 

        it "indicates that the player does not win vertically with three stones" do 
            3.times do |cell| 
                @game.board.field[cell][0] = @game.player_one.sign 
            end

            3.times do |cell| 
                @game.board.field[cell][1] = @game.player_two.sign 
            end

            expect(@game.win?).to eq(false)
        end

        it "indicates that player does not win when sum of old and new column is 4" do 
            # Last cell of column 2
            @game.board.field[5][2] = @game.player_one.sign 

            # First three cells of column 3
            3.times do |cell| 
                @game.board.field[cell][3] = @game.player_one.sign 
            end 

            expect(@game.vertical_win?).to eq(false)
        end 

        it "indicates when a player does not win vertically" do 
            3.times do |cell| 
                @game.board.field[cell][3] = @game.player_one.sign 
            end 

            expect(@game.vertical_win?).to eq(false)
        end 

        it "indicates when a player wins diagonally descending" do
            row = 1 
            column = 0 
           
            4.times do 
                @game.board.field[row][column] = @game.player_one.sign 
                row += 1
                column += 1
            end

            expect(@game.diagonal_win?).to eq(true)
        end

        it "indicates when a player wins diagonally ascending" do
            row = 0
            column = 6 
           
            4.times do 
                @game.board.field[row][column] = @game.player_one.sign 
                row += 1
                column -= 1
            end

            expect(@game.diagonal_win?).to eq(true)
        end
    end
end 