# frozen_string_literal: true

require_relative 'figure'

class Pawn
  attr_reader :row, :column, :possible_moves, :color, :display

  include Figure

  def initialize(color, row, column)
    @color = color
    @row = row
    @column = column
    @display = @display = { white: '♟', black: '♙' }
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

  def update_possible_moves(board)
    # delete moves with obstacle
    @possible_moves.each do |tile|
      unless board.find_figure(:black, tile[0], tile[1]).nil? && board.find_figure(:white, tile[0], tile[1]).nil?
        @possible_moves -= [tile]
      end
    end
    # add moves with kill opportunity
    if @color == :white
      if board.find_figure(:black, @row - 1, @column - 1)
        @possible_moves.push([@row - 1, @column - 1])
      elsif board.find_figure(:black, @row - 1, @column + 1)
        @possible_moves.push([@row - 1, @column + 1])
      end
    elsif board.find_figure(:white, @row + 1, @column - 1)
      @possible_moves.push([@row + 1, @column - 1])
    elsif board.find_figure(:white, @row + 1, @column + 1)
      @possible_moves.push([@row + 1, @column + 1])
    end
  end
end
