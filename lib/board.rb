require 'observer'
class GameError < StandardError
end
class Board
  include Observable

  def initialize(dimension, valid_tokens)
    @valid_tokens = valid_tokens
    @position_hash = Hash.new
    @played_token = valid_tokens.last
    @dimension = dimension
  end

  def place!(token, position)
    validate_token(token)
    validate_position(position)
    @position_hash[position] = token
    @played_token = token
    check_game_end
  end


  def expected_player
    @valid_tokens[expected_turn]
  end


  def symbol_at(position)
    @position_hash[position]
  end

  private
  def validate_token(token)
    unless turn_of(token) == expected_turn
      raise GameError, "Expected #{expected_player} to play"
    end
  end

  def validate_position(position)
    unless position.is_within(@dimension) and cell_empty_at(position)
      raise GameError, "Expected position to be within boundary of #{@dimension}"
    end
  end

  def cell_empty_at(position)
    symbol_at(position).nil?
  end

  def turn_of(token)
    @valid_tokens.index(token)
  end

  def expected_turn
    (turn_of(@played_token) + 1) % @valid_tokens.length
  end

  def check_game_end
    @dimension.rows.each do |row|
      winner_token = @valid_tokens.find do |token|
        row.all? {|position| symbol_at(position) == token }
      end
      unless winner_token.nil?
        self.changed
        notify_observers(:won, winner_token)
      end
    end
  end
  
end