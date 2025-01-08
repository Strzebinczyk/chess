# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  let(:game) { described_class.new }

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
    # 8  | ♖  | ♘  | ♗  | ♔  | ♕  | ♗  | ♘  | ♖  |
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
    # 1  | ♜  | ♞  | ♝  | ♚  | ♛  | ♝  | ♞  | ♜  |
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

    it 'removes enemy figure from board if it is on the end point' do # rubocop:disable RSpec/ExampleLength
      position = [6, 0]
      killed_pawn = game.board.find_figure(position)
      game.move('a2 to a4')
      game.move('b7 to b5')
      game.move('a1 to a3')
      game.move('b5 to a4')
      # Board after moves:
      #    +----+----+----+----+----+----+----+----+
      # 8  | ♖  | ♘  | ♗  | ♔  | ♕  | ♗  | ♘  | ♖  |
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
      # 1  |    | ♞  | ♝  | ♚  | ♛  | ♝  | ♞  | ♜  |
      #    +----+----+----+----+----+----+----+----+
      #      a    b    c    d    e    f    g    h
      # Active player is white
      expect(game.board.figures.values.include?(killed_pawn)).to be false
    end

    it 'returns :ok if move was executed correctly' do
      expect(game.move('a2 to a4')).to be :ok
    end

    context 'check moving in every direction' do # rubocop:disable RSpec/ContextWording
      let(:game2) { described_class.new }

      it 'moves verically up' do
        expect(game2.move('a2 to a4')).to be :ok
      end

      it 'moves verically down' do
        expect(game2.move('a7 to a5')).to be :ok
      end

      it 'moves horizontally right' do
        game2.move('a2a4')
        game2.move('a1a3')
        expect(game2.move('a3 to h3')).to be :ok
      end

      it 'moves horizontally left' do
        game2.move('a2a4')
        game2.move('a1a3')
        game2.move('a3g3')
        expect(game2.move('g3 to a3')).to be :ok
      end

      it 'moves diagonally up and left' do
        game2.move('b2b4')
        expect(game2.move('c1 to a3')).to be :ok
      end

      it 'moves diagonally up and right' do
        game2.move('b2b4')
        game2.move('c1 to b2')
        expect(game2.move('b2f6')).to be :ok
      end

      it 'moves diagonally down and right' do
        game2.move('b2b4')
        game2.move('c1 to b2')
        game2.move('b2f6')
        expect(game2.move('f6h4')).to be :ok
      end

      it 'moves diagonally down and left' do
        game2.move('b2b4')
        game2.move('c1 to b2')
        game2.move('b2f6')
        expect(game2.move('f6d4')).to be :ok
      end

      it 'moves a knight' do
        expect(game2.move('b8a6')).to be :ok
      end
    end
  end

  describe '#checkmate?' do
    let(:game3) { described_class.new }

    it "returns false if there's no checkmate" do
      game3.move('c2 to c3')
      game3.move('d7 to d5')
      game3.move('b2 to b4')
      # Board after moves:
      #    +----+----+----+----+----+----+----+----+
      # 8  | ♖  | ♘  | ♗  | ♔  | ♕  | ♗  | ♘  | ♖  |
      #    +----+----+----+----+----+----+----+----+
      # 7  | ♙  | ♙  | ♙  |    | ♙  | ♙  | ♙  | ♙  |
      #    +----+----+----+----+----+----+----+----+
      # 6  |    |    |    |    |    |    |    |    |
      #    +----+----+----+----+----+----+----+----+
      # 5  |    |    |    | ♙  |    |    |    |    |
      #    +----+----+----+----+----+----+----+----+
      # 4  |    | ♟  |    |    |    |    |    |    |
      #    +----+----+----+----+----+----+----+----+
      # 3  |    |    | ♟  |    |    |    |    |    |
      #    +----+----+----+----+----+----+----+----+
      # 2  | ♟  |    |    | ♟  | ♟  | ♟  | ♟  | ♟  |
      #    +----+----+----+----+----+----+----+----+
      # 1  | ♜  | ♞  | ♝  | ♚  | ♛  | ♝  | ♞  | ♜  |
      #    +----+----+----+----+----+----+----+----+
      #      a    b    c    d    e    f    g    h
      # Active player is black

      expect(game3.checkmate?).to be false
    end

    it "returns true if there's checkmate" do
      game3.move('c2 to c3')
      game3.move('d7 to d5')
      game3.move('b2 to b4')
      game3.move('d1 to a4')
      # Board after moves:
      #    +----+----+----+----+----+----+----+----+
      # 8  | ♖  | ♘  | ♗  | ♔  | ♕  | ♗  | ♘  | ♖  |
      #    +----+----+----+----+----+----+----+----+
      # 7  | ♙  | ♙  | ♙  |    | ♙  | ♙  | ♙  | ♙  |
      #    +----+----+----+----+----+----+----+----+
      # 6  |    |    |    |    |    |    |    |    |
      #    +----+----+----+----+----+----+----+----+
      # 5  |    |    |    | ♙  |    |    |    |    |
      #    +----+----+----+----+----+----+----+----+
      # 4  | ♚  | ♟  |    |    |    |    |    |    |
      #    +----+----+----+----+----+----+----+----+
      # 3  |    |    | ♟  |    |    |    |    |    |
      #    +----+----+----+----+----+----+----+----+
      # 2  | ♟  |    |    | ♟  | ♟  | ♟  | ♟  | ♟  |
      #    +----+----+----+----+----+----+----+----+
      # 1  | ♜  | ♞  | ♝  |    | ♛  | ♝  | ♞  | ♜  |
      #    +----+----+----+----+----+----+----+----+
      #      a    b    c    d    e    f    g    h
      # Active player is black
      expect(game3.checkmate?).to be true
    end
  end

  describe '#check?' do
    let(:game4) { described_class.new }

    it 'returns false if there is no check' do
      expect(game4.check?).to be false
    end

    it 'returns true if there is a check' do
      # change active player to black
      game4.change_active_player
      game4.move('b8 to c6')
      game4.move('c6d4')
      game4.move('d4f3')
      expect(game4.check?).to be true
    end
  end
end
