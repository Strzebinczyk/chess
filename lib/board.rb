# frozen_string_literal: true

require_relative 'figures/knight'
require_relative 'figures/rook'
require_relative 'figures/bishop'
require_relative 'figures/king'
require_relative 'figures/queen'
require_relative 'figures/pawn'

class Board
  attr_reader :figures

  def initialize
    @figures = { white: {}, black: {} }
    prepare_board
  end

  def prepare_board
    @figures[:white][:rook1] = Rook.new(:white, 7, 0)
    @figures[:white][:knight1] = Knight.new(:white, 7, 1)
    @figures[:white][:bishop1] = Bishop.new(:white, 7, 2)
    @figures[:white][:king] = King.new(:white, 7, 3)
    @figures[:white][:queen] = Queen.new(:white, 7, 4)
    @figures[:white][:bishop2] = Bishop.new(:white, 7, 5)
    @figures[:white][:knight2] = Knight.new(:white, 7, 6)
    @figures[:white][:rook2] = Rook.new(:white, 7, 7)

    @figures[:white][:pawn1] = Pawn.new(:white, 6, 0)
    @figures[:white][:pawn2] = Pawn.new(:white, 6, 1)
    @figures[:white][:pawn3] = Pawn.new(:white, 6, 2)
    @figures[:white][:pawn4] = Pawn.new(:white, 6, 3)
    @figures[:white][:pawn5] = Pawn.new(:white, 6, 4)
    @figures[:white][:pawn6] = Pawn.new(:white, 6, 5)
    @figures[:white][:pawn7] = Pawn.new(:white, 6, 6)
    @figures[:white][:pawn8] = Pawn.new(:white, 6, 7)

    @figures[:black][:rook1] = Rook.new(:black, 0, 0)
    @figures[:black][:knight1] = Knight.new(:black, 0, 1)
    @figures[:black][:bishop1] = Bishop.new(:black, 0, 2)
    @figures[:black][:king] = King.new(:black, 0, 3)
    @figures[:black][:queen] = Queen.new(:black, 0, 4)
    @figures[:black][:bishop2] = Bishop.new(:black, 0, 5)
    @figures[:black][:knight2] = Knight.new(:black, 0, 6)
    @figures[:black][:rook2] = Rook.new(:black, 0, 7)

    @figures[:black][:pawn1] = Pawn.new(:black, 1, 0)
    @figures[:black][:pawn2] = Pawn.new(:black, 1, 1)
    @figures[:black][:pawn3] = Pawn.new(:black, 1, 2)
    @figures[:black][:pawn4] = Pawn.new(:black, 1, 3)
    @figures[:black][:pawn5] = Pawn.new(:black, 1, 4)
    @figures[:black][:pawn6] = Pawn.new(:black, 1, 5)
    @figures[:black][:pawn7] = Pawn.new(:black, 1, 6)
    @figures[:black][:pawn8] = Pawn.new(:black, 1, 7)
  end

  def find_figure(color, row, column)
    @figures[color].each_value do |figure|
      return figure if figure.row == row && figure.column == column
    end
    nil
  end

  def kill(figure)
    color = figure.color
    key = @figures[color].key(figure)
    @figures[color].delete(key)
  end

  def display
    positions = Array.new(8) { Array.new(8, nil) }
    @figures.each_key do |color|
      @figures[color].each_value do |figure|
        positions[figure.row][figure.column] = figure.display[color]
      end
    end
    positions
  end
end
