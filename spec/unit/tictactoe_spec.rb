require_relative '../spec_helper'

RSpec.describe "In TicTacToe, " do
  subject(:tictactoe) { Board.new(dimension, [player_x, player_o]) }

  let!(:dimension) { Dimension.new(3, 3) }
  let!(:player_x) { Token.new('X') }
  let!(:player_o) { Token.new('O') }
  let(:three_by_three) { Position.new(2, 2) }

  it "should allow placement of symbols" do 
    tictactoe.place!(player_x, three_by_three);
    expect(tictactoe.symbol_at(three_by_three)).to equal(player_x)
  end

  it "should not allow placing tokens in an occupied cell" do
    tictactoe.place!(player_x, three_by_three)

    expect {
      tictactoe.place!(player_o, three_by_three)
    }.to raise_error GameError
  end

  context 'Winner declaration, ' do
    it "should declare winner, when same symbol placed consecutively thrice in a row" do
      coordinator = double("Game Coordinator")
      allow(coordinator).to receive(:finish_game)

      tictactoe.add_observer(coordinator, :finish_game)

      tictactoe.place!(player_x, Position.new(0,0))
      tictactoe.place!(player_o, Position.new(1,0))
      tictactoe.place!(player_x, Position.new(0,1))
      tictactoe.place!(player_o, Position.new(1,1))
      tictactoe.place!(player_x, Position.new(0,2))

      expect(coordinator).to have_received(:finish_game).with(:won, player_x)

    end
  end

  context "For a 3by3 board, " do
    [
     {x: 0, y: 0}, {x: 0, y: 1}, {x: 0, y: 2}, 
     {x: 1, y: 0}, {x: 1, y: 1}, {x: 1, y: 2}, 
     {x: 2, y: 0}, {x: 2, y: 1}, {x: 2, y: 2}
    ].each do |coordinates|
      it "should allow #{coordinates} position" do
        within_board = Position.new(coordinates[:x], coordinates[:y])
        expect {
          tictactoe.place!(player_x, within_board)
        }.not_to raise_error
      end
    end

    [
     {x: 0, y: -1}, {x: -1, y: 0}, {x: 0, y: 3}, {x: 3, y: 2}, {x: 3, y: 3}
    ].each do |coordinates|
      it "should not allow #{coordinates} position" do
        outside_board = Position.new(coordinates[:x], coordinates[:y])
        expect {
          tictactoe.place!(player_x, outside_board);  
        }.to raise_error GameError
      end
    end


  end
  

  context 'Game start' do
    
    it 'should allow only first player start the game' do 
      tictactoe.place!(player_x, three_by_three);
    end

    it 'should not allow any other players(but the first player) to start' do 
      expect {
        tictactoe.place!(player_o, three_by_three);  
      }.to raise_error GameError
    end
  end

  context "In a three player game[player_x, player_o, player_star]," do

    subject(:tictactoe) { Board.new(dimension, [player_x, player_o, player_star]) }
    let!(:player_star) { Token.new('*') }

    it "should not allow if player_x plays consecutively" do
      tictactoe.place!(player_x, Position.new(0,0))
      expect {
        tictactoe.place!(player_x, Position.new(1,0))
      }.to raise_error GameError

    end


    it "should not allow if player_x plays immediately after player_o" do
      tictactoe.place!(player_x, Position.new(0,0))
      tictactoe.place!(player_o, Position.new(0,1))
      expect {
        tictactoe.place!(player_x, Position.new(1,0))
      }.to raise_error GameError
    end


    it "should ensure symbols alternate" do
      tictactoe.place!(player_x, Position.new(0,0))
      tictactoe.place!(player_o, Position.new(1,0))
      tictactoe.place!(player_star, Position.new(2,0))
      tictactoe.place!(player_x, Position.new(0,1))
      tictactoe.place!(player_o, Position.new(0,2))
    end

  end

end