# frozen_string_literal: true

require_relative 'board'

class Game
  attr_reader :board, :active_player

  def initialize
    @board = Board.new
    @active_player = :white
    @players = %i[white black]
  end

  def to_figure(string)
    figures = { 'rook' => %i[rook1 rook2 rook], 'knight' => %i[knight1 knight2 knight],
                'bishop' => %i[bishop1 bishop2 bishop], 'king' => %i[king king], 'queen' => %i[queen queen],
                'pawn' => %i[pawn1 pawn2 pawn3 pawn4 pawn5 pawn6 pawn7 pawn8 pawn] }
    figures[string]
  end

  def compute_path(figure, start, stop)
    path = [start]
    if figure.is_a?(Knight)
      path.push(stop)
      return path
    end
    current = start
    rows = stop[0] - start[0]
    columns = stop[1] - start[1]
    if rows.zero? && columns.positive?
      until current == stop
        current = [current[0], (current[1] + 1)]
        path.push(current)
      end
    elsif rows.zero? && columns.negative?
      until current == stop
        current = [current[0], (current[1] - 1)]
        path.push(current)
      end
    elsif rows.positive? && columns.zero?
      until current == stop
        current = [(current[0] + 1), current[1]]
        path.push(current)
      end
    elsif rows.negative? && columns.zero?
      until current == stop
        current = [(current[0] - 1), current[1]]
        path.push(current)
      end
    elsif rows.positive? && columns.positive?
      until current == stop
        current = [(current[0] + 1), (current[1] + 1)]
        path.push(current)
      end
    elsif rows.positive? && columns.negative?
      until current == stop
        current = [(current[0] + 1), (current[1] - 1)]
        path.push(current)
      end
    elsif rows.negative? && columns.positive?
      until current == stop
        current = [(current[0] - 1), (current[1] + 1)]
        path.push(current)
      end
    elsif rows.negative? && columns.negative?
      until current == stop
        current = [(current[0] + - 1), (current[1] - 1)]
        path.push(current)
      end
    end
    path
  end

  def enemy?(row, column)
    enemy = if @active_player == :white
              @board.display[:black]
            else
              @board.display[:white]
            end
    enemy.values.include?(@board.positions[row][column])
  end

  def no_obstacles?(path)
    # Get rid of starting spot
    path.shift
    # Get rid of ending point and return false if there is friendly figure on it
    last_tile = path.pop
    return false unless enemy?(last_tile[0], last_tile[1]) || @board.positions[last_tile[0]][last_tile[1]].nil?

    path.each do |tile|
      return false unless @board.positions[tile[0]][tile[1]].nil?
    end
    true
  end

  def move_possible?(figure, row, column)
    possible_moves = figure.possible_moves
    return false if possible_moves.nil?

    return true if possible_moves.include?([row, column])

    false
  end

  def kill(row, column)
    figure = if @active_player == :white
               board.find_figure(:black, row, column)
             else
               board.find_figure(:white, row, column)
             end

    board.kill(figure)
    figure.kill
  end

  # Not finished! Need exceptions for invalid movesrook
  def move(figure, row, column, color = @active_player)
    figure_vector = to_figure(figure)
    figure_symbol = figure_vector.pop
    color_figures = @board.display[color]
    figure_vector.each do |fig|
      fig = @board.figures[color][fig]
      figure = fig if move_possible?(fig, row, column)
    end
    puts 'Move not possible' if figure.is_a?(String)
    path = compute_path(figure, [figure.row, figure.column], [row, column])
    puts 'Obstacles!' unless no_obstacles?(path)
    @board.clear_position(figure.row, figure.column)
    figure.change_position(row, column)
    @board.change_position(row, column, color_figures[figure_symbol])
    kill(row, column) if enemy?(row, column)
  end

  def valid_figure?(figure)
    figures = %w[pawn rook bishop king queen knight]
    figures.include?(figure)
  end

  def find_enemy_king
    if active_player == :white
      @board.figures[:black][:king]
    else
      @board.figures[:white][:king]
    end
  end

  def check?
    enemy_king = find_enemy_king
    enemy_king_position = [enemy_king.row, enemy_king.column]
    figures = if active_player == :white
                @board.figures[:white]
              else
                @board.figures[:black]
              end
    figures.each_value do |figure|
      return true if figure.possible_moves.include?(enemy_king_position)
    end
    false
  end

  def checkmate?
    enemy_king = find_enemy_king
    if check?
      enemy_king.possible_moves.each do |move|
        return false if move_possible?(enemy_king, move[0], move[1])
      end
      return true
    end
    false
  end

  def change_active_player
    @active_player = if @active_player == :white
                       :black
                     else
                       :white
                     end
  end
end
