# frozen_string_literal: true

require_relative 'figure'

class Knight
  attr_reader :row, :column, :possible_moves

  include Figure

  def initialize(color, row, column)
    @color = color
    @row = row
    @column = column
    @move_pattern = [[-2, -1], [-2, 1], [2, -1], [2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2]]
    @possible_moves = find_possible_moves
  end
end
