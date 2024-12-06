# frozen_string_literal: true

require_relative 'figures/knight'
require_relative 'figures/rook'
require_relative 'figures/bishop'
require_relative 'figures/king'
require_relative 'figures/queen'
require_relative 'figures/pawn'

class Board
  attr_reader :positions, :white_figures, :black_figures

  def initialize
    @display = { white: { queen: '♚', king: '♛', rook: '♜', bishop: '♝', knight: '♞', pawn: '♟' },
                 black: { queen: '♔', king: '♕', rook: '♖', bishop: '♗', knight: '♘', pawn: '♙' } }
    @figures = { white: {}, black: {} }
    @positions = Array.new(8) { Array.new(8, nil) }
    prepare_board
  end

  def prepare_board
    @figures[:white][:rook1] = Rook.new(:white, 7, 0)
    @positions[7][0] = @display[:white][:rook]
    @figures[:white][:knight1] = Knight.new(:white, 7, 1)
    @positions[7][1] = @display[:white][:knight]
    @figures[:white][:bishop1] = Bishop.new(:white, 7, 2)
    @positions[7][2] = @display[:white][:bishop]
    @figures[:white][:king] = King.new(:white, 7, 3)
    @positions[7][3] = @display[:white][:king]
    @figures[:white][:queen] = Queen.new(:white, 7, 4)
    @positions[7][4] = @display[:white][:queen]
    @figures[:white][:bishop2] = Bishop.new(:white, 7, 5)
    @positions[7][5] = @display[:white][:bishop]
    @figures[:white][:knight2] = Knight.new(:white, 7, 6)
    @positions[7][6] = @display[:white][:knight]
    @figures[:white][:rook2] = Rook.new(:white, 7, 7)
    @positions[7][7] = @display[:white][:rook]

    @figures[:white][:pawn1] = Pawn.new(:white, 6, 0)
    @positions[6][0] = @display[:white][:pawn]
    @figures[:white][:pawn2] = Pawn.new(:white, 6, 1)
    @positions[6][1] = @display[:white][:pawn]
    @figures[:white][:pawn3] = Pawn.new(:white, 6, 2)
    @positions[6][2] = @display[:white][:pawn]
    @figures[:white][:pawn4] = Pawn.new(:white, 6, 3)
    @positions[6][3] = @display[:white][:pawn]
    @figures[:white][:pawn5] = Pawn.new(:white, 6, 4)
    @positions[6][4] = @display[:white][:pawn]
    @figures[:white][:pawn6] = Pawn.new(:white, 6, 5)
    @positions[6][5] = @display[:white][:pawn]
    @figures[:white][:pawn7] = Pawn.new(:white, 6, 6)
    @positions[6][6] = @display[:white][:pawn]
    @figures[:white][:pawn8] = Pawn.new(:white, 6, 7)
    @positions[6][7] = @display[:white][:pawn]

    @figures[:black][:rook1] = Rook.new(:black, 0, 0)
    @positions[0][0] = @display[:black][:rook]
    @figures[:black][:knight1] = Knight.new(:black, 0, 1)
    @positions[0][1] = @display[:black][:knight]
    @figures[:black][:bishop1] = Bishop.new(:black, 0, 2)
    @positions[0][2] = @display[:black][:bishop]
    @figures[:black][:king] = King.new(:black, 0, 3)
    @positions[0][3] = @display[:black][:king]
    @figures[:black][:queen] = Queen.new(:black, 0, 4)
    @positions[0][4] = @display[:black][:queen]
    @figures[:black][:bishop2] = Bishop.new(:black, 0, 5)
    @positions[0][5] = @display[:black][:bishop]
    @figures[:black][:knight2] = Knight.new(:black, 0, 6)
    @positions[0][6] = @display[:black][:knight]
    @figures[:black][:rook2] = Rook.new(:black, 0, 7)
    @positions[0][7] = @display[:black][:rook]

    @figures[:black][:pawn1] = Pawn.new(:black, 1, 0)
    @positions[1][0] = @display[:black][:pawn]
    @figures[:black][:pawn2] = Pawn.new(:black, 1, 1)
    @positions[1][1] = @display[:black][:pawn]
    @figures[:black][:pawn3] = Pawn.new(:black, 1, 2)
    @positions[1][2] = @display[:black][:pawn]
    @figures[:black][:pawn4] = Pawn.new(:black, 1, 3)
    @positions[1][3] = @display[:black][:pawn]
    @figures[:black][:pawn5] = Pawn.new(:black, 1, 4)
    @positions[1][4] = @display[:black][:pawn]
    @figures[:black][:pawn6] = Pawn.new(:black, 1, 5)
    @positions[1][5] = @display[:black][:pawn]
    @figures[:black][:pawn7] = Pawn.new(:black, 1, 6)
    @positions[1][6] = @display[:black][:pawn]
    @figures[:black][:pawn8] = Pawn.new(:black, 1, 7)
    @positions[1][7] = @display[:black][:pawn]
  end

  def clear_position(row, column)
    @positions[row][column] = nil
  end

  def change_position(row, column, symbol)
    @positions[row][column] = symbol
  end
end
