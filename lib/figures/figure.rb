# frozen_string_literal: true

class Figure
  attr_reader :row, :column, :possible_moves, :color, :display, :move_pattern

  def initialize(color, row, column)
    @color = color
    @row = row
    @column = column
  end

  def change_position(position)
    @row = position[0]
    @column = position[1]
  end
end
