# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new }

  describe '#compute_path' do
    it 'takes a figure, starting and stopping point and returns a path the figure has to make' do
      start = [7, 0]
      stop = [3, 0]
      rook = Rook.new(:white, 7, 0)
      path = [[7, 0], [6, 0], [5, 0], [4, 0], [3, 0]]
      expect(game.compute_path(rook, start, stop)).to eql path
    end

    it 'calculates path of a bishop' do
      start = [7, 0]
      stop = [0, 7]
      bishop = Bishop.new(:white, 7, 0)
      path = [[7, 0], [6, 1], [5, 2], [4, 3], [3, 4], [2, 5], [1, 6], [0, 7]]
      expect(game.compute_path(bishop, start, stop)).to eql path
    end

    it 'calculates path of a pawn' do
      start = [6, 3]
      stop = [4, 3]
      pawn = Pawn.new(:white, 6, 3)
      path = [[6, 3], [5, 3], [4, 3]]
      expect(game.compute_path(pawn, start, stop)).to eql path
    end
  end

  describe '#enemy?' do
    it 'takes row and column and returns true if position is taken by the enemy' do
      expect(game.enemy?(0, 0)).to be true
    end

    it 'returns false if position is unoccupied or there is a friendly figure there' do
      expect(game.enemy?(6, 2)).to be false
    end
  end

  describe '#no_obstacles?' do
    it 'returns true if the path is clear without other pieces in the way' do
      path = [[3, 0], [3, 1], [3, 2], [3, 3], [3, 4], [3, 5], [3, 6], [3, 7]]
      expect(game.no_obstacles?(path)).to be true
    end

    it 'returns false if there are obstacles' do
      path = [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7]]
      expect(game.no_obstacles?(path)).to be false
    end
  end

  describe '#move_possible?' do
    it 'returns true if the move is possible' do
      rook = Rook.new(:white, 7, 0)
      expect(game.move_possible?(rook, 3, 0)).to be true
    end

    it 'returns false if the move is not possible' do
      rook = Rook.new(:white, 7, 0)
      expect(game.move_possible?(rook, 3, 3)).to be false
    end
  end
end
