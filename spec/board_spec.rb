# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  let(:board) { described_class.new }

  describe '#find_figure' do
    it 'returns a figure if there is one at position' do
      figure = Rook.new(:black, 5, 5)
      board.figures[:black][:test] = figure
      expect(board.find_figure([5, 5])).to be figure
    end

    it 'returns nil if there is no figure at position' do
      expect(board.find_figure([5, 5])).to be_nil
    end
  end

  describe '#kill' do
    it 'removes the figure' do
      board.figures[:white][:test] = Rook.new(:white, 5, 5)
      board.kill([5, 5])
      expect(board.find_figure([5, 5])).to be_nil
    end
  end

  describe '#display' do
    it 'returns a hash of positions and figures' do
      expect(board.display.length).to be 32
    end
  end

  describe '#find_possible_moves' do
    it 'returns an array of possible moves for figure' do
      figure =  Pawn.new(:white, 5, 5)
      board.figures[:white][:test] = figure
      expect(board.find_possible_moves(figure)).to eql [[4, 5]]
    end
  end
end
