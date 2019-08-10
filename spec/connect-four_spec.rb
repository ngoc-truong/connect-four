require "./lib/connect-four"

describe Player do 
    before { @player = Player.new("#{color}") } 

    context "Player has yellow figures" do 
        let(:color) { "yellow" }

        it "has yellow figure" do 
            expect(@player.color).to eq("yellow")
        end
    end 

    context "Initiating player with wrong color" do 
        let(:color) { "green" }

        it "does not set the color to green but nil" do 
            expect(@player.color).to eq(nil)
        end
    end 

    context "Player can choose a number." do 
        let(:color) { "yellow" }

        it "chooses a correct number" do 
            expect(@player.choose_column).to be_between(1, 7)
        end 
    end

end 


describe Board do 
    before { @board = Board.new }

    context "Creating the board" do 
        it "creates a board in a two dimensional array" do 
            expect(@board.create_board).to eq( [    ["", "", "", "", "", "", ""],
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
end 