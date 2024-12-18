# frozen_string_literal: true

require_relative 'figure'

class Pawn < Figure
  def display
    return '♟' if @color == :white

    '♙'
  end

  def move_pattern
    result = []
    if @color == :white
      result.push([-2, 0]) if @row == 6
      result.push([-1, 0])
    else
      result.push([2, 0]) if @row == 1
      result.push([1, 0])
    end
    result
  end

  def update_move_pattern
    result = []
    if @color == :white
      result.push([-2, 0]) if @row == 6
      result.push([-1, 0])
    else
      result.push([2, 0]) if @row == 1
      result.push([1, 0])
    end
    @move_pattern = result
  end
end
