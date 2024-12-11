# frozen_string_literal: true

require_relative 'figure'

class Bishop
  attr_reader :row, :column, :possible_moves, :color

  include Figure

  def initialize(color, row, column)
    @color = color
    @row = row
    @column = column
    @move_pattern = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
                     [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
                     [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7],
                     [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7]]
    @possible_moves = find_possible_moves
  end
end
