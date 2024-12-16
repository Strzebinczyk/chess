# frozen_string_literal: true

require_relative 'figure'

class Rook
  attr_reader :row, :column, :possible_moves, :color, :display

  include Figure

  def initialize(color, row, column)
    @color = color
    @row = row
    @column = column
    @display = { white: '♜', black: '♖' }
    @move_pattern = [[-7, 0], [-6, 0], [-5, 0], [-4, 0], [-3, 0], [-2, 0], [-1, 0],
                     [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
                     [0, -7], [0, -6], [0, -5], [0, -4], [0, -3], [0, -2], [0, -1],
                     [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]]
    @possible_moves = find_possible_moves
  end
end
