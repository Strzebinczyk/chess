# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new }

  describe '#valid_input?' do
    it 'returns true if the input has a valid position at the start and end of string' do
      input = 'a5 to the a6'
      expect(game.valid_input?(input)).to be true
    end

    it 'returns false when the start or end position is missing' do
      input = 'a7 to wherever'
      expect(game.valid_input?(input)).to be false
    end
  end

  describe '#change_active_player' do
    it 'changes active player to black after it was white on initialize' do
      game.change_active_player
      expect(game.active_player).to be :black
    end

    it 'changes active player back to white after it was black' do
      game.change_active_player
      game.change_active_player
      expect(game.active_player).to be :white
    end
  end

  describe '#move' do
    # Board starting point:
    #    +----+----+----+----+----+----+----+----+
    # 8  | ♖  | ♘  | ♗  | ♕  | ♔  | ♗  | ♘  | ♖  |
    #    +----+----+----+----+----+----+----+----+
    # 7  | ♙  | ♙  | ♙  | ♙  | ♙  | ♙  | ♙  | ♙  |
    #    +----+----+----+----+----+----+----+----+
    # 6  |    |    |    |    |    |    |    |    |
    #    +----+----+----+----+----+----+----+----+
    # 5  |    |    |    |    |    |    |    |    |
    #    +----+----+----+----+----+----+----+----+
    # 4  |    |    |    |    |    |    |    |    |
    #    +----+----+----+----+----+----+----+----+
    # 3  |    |    |    |    |    |    |    |    |
    #    +----+----+----+----+----+----+----+----+
    # 2  | ♟  | ♟  | ♟  | ♟  | ♟  | ♟  | ♟  | ♟  |
    #    +----+----+----+----+----+----+----+----+
    # 1  | ♜  | ♞  | ♝  | ♛  | ♚  | ♝  | ♞  | ♜  |
    #    +----+----+----+----+----+----+----+----+
    #      a    b    c    d    e    f    g    h
    # Active player is white

    it 'moves the figure from one place to another if the move is possible' do
      position = [6, 0]
      moved_pawn = game.board.find_figure(position)
      game.move('a2 to a4')
      expect(moved_pawn.row).to be 4
    end

    it 'returns [:error, :no_figure_on_start] if the starting point is empty' do
      expect(game.move('a3 to a4')).to eql %i[error no_figure_on_start]
    end

    it 'returns [:error, :move_not_possible] if move is not in the array of possible moves' do
      expect(game.move('a2 to h4')).to eql %i[error move_not_possible]
    end

    it 'returns [:error, :obstacle] if there is another figure in the way' do
      expect(game.move('a1 to a4')).to eql %i[error obstacle]
    end

    it 'removes enemy figure from board if it is on the end point' do
      position = [6, 0]
      killed_pawn = game.board.find_figure(position)
      game.move('a2 to a4')
      game.move('b7 to b5')
      game.move('a1 to a3')
      game.move('b5 to a4')
      # Board after moves:
      #    +----+----+----+----+----+----+----+----+
      # 8  | ♖  | ♘  | ♗  | ♕  | ♔  | ♗  | ♘  | ♖  |
      #    +----+----+----+----+----+----+----+----+
      # 7  | ♙  |    | ♙  | ♙  | ♙  | ♙  | ♙  | ♙  |
      #    +----+----+----+----+----+----+----+----+
      # 6  |    |    |    |    |    |    |    |    |
      #    +----+----+----+----+----+----+----+----+
      # 5  |    |    |    |    |    |    |    |    |
      #    +----+----+----+----+----+----+----+----+
      # 4  | ♙  |    |    |    |    |    |    |    |
      #    +----+----+----+----+----+----+----+----+
      # 3  | ♜  |    |    |    |    |    |    |    |
      #    +----+----+----+----+----+----+----+----+
      # 2  |    | ♟  | ♟  | ♟  | ♟  | ♟  | ♟  | ♟  |
      #    +----+----+----+----+----+----+----+----+
      # 1  |    | ♞  | ♝  | ♛  | ♚  | ♝  | ♞  | ♜  |
      #    +----+----+----+----+----+----+----+----+
      #      a    b    c    d    e    f    g    h
      # Active player is white
      expect(game.board.figures.values.include?(killed_pawn)).to be false
    end

    it 'returns :ok if move was executed correctly' do
      expect(game.move('a2 to a4')).to be :ok
    end
  end
  # check, checkmate
end
