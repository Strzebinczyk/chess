# frozen_string_literal: true

require_relative '../lib/figures/figure'
require_relative '../lib/figures/king'

describe Figure do
  subject(:king) { King.new(:white, 3, 3) }

  describe '#find_possible_moves' do
    it 'returns array of possible moves based on move pattern' do
      result = [[2, 2], [2, 3], [2, 4], [3, 2], [3, 4], [4, 2], [4, 3], [4, 4]]
      expect(king.possible_moves).to include(*result)
    end
  end

  describe '#change_position' do
    it 'changes instance variables of row and column' do
      row = 4
      column = 4
      king.change_position(row, column)
      kings_position = [king.row, king.column]
      expect(kings_position).to eql([row, column])
    end
  end

  describe '#kill' do
    king.kill
    it 'changes row and column instance variables to nil' do
      kings_position = [king.row, king.column]
      expect(kings_position).to eql [nil, nil]
    end

    it 'changes possible_moves to nil' do
      possible_moves = king.possible_moves
      expect(possible_moves).to be_nil
    end
  end
end
