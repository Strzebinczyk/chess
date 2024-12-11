# frozen_string_literal: true

require_relative 'figure'

class Pawn
  attr_reader :row, :column, :possible_moves, :color

  include Figure

  def initialize(color, row, column)
    @color = color
    @row = row
    @column = column
    @move_pattern = find_move_pattern
    @possible_moves = find_possible_moves
  end

  def find_move_pattern
    result = []
    if @color == :white
      result.push([-2, 0]) if @row == 6
      result.push([-1, 0])
    else
      result.push([2, 0]) if @row == 1
      result.push([1, 0])
    end
  end

  def find_possible_moves
    @move_pattern = find_move_pattern
    result = []
    @move_pattern.each do |option|
      row = @row + option[0]
      column = @column + option[1]
      if (row in 0..7) && (column in 0..7)
        result.push([row, column])
      end
    end
    result
  end
end
