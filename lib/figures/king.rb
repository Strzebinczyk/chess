# frozen_string_literal: true

require_relative 'figure'

class King
  attr_reader :row, :column, :possible_moves

  include Figure

  def initialize(color, row, column)
    @color = color
    @row = row
    @column = column
    @move_pattern = [[1, 0], [1, 1], [0, 1], [0, -1], [-1, -1], [-1, 0], [-1, 1], [1, -1]]
    @possible_moves = find_possible_moves
  end
end
