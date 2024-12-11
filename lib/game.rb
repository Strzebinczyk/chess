# frozen_string_literal: true

require_relative 'board'

class Game
  attr_reader :board

  def initialize
    @board = Board.new
    @active_player = :white
    @players = %i[white black]
  end

  def to_figure(string)
    figures = { 'rook' => %i[rook1 rook2 rook], 'knight' => %i[knight1 knight2 knight],
                'bishop' => %i[bishop1 bishop2 bishop], 'king' => [:king], 'queen' => [:queen],
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

    path = compute_path(figure, [figure.row, figure.column], [row, column])
    return true if possible_moves.include?([row, column]) && no_obstacles?(path)

    false
  end

  def kill(row, column)
    figure = if @active_player == :white
               board.find_figure(:black, row, column)
             else
               board.find_figure(:white, row, column)
             end

    figure.kill
  end

  def move(color = @active_player, figure, row, column)
    figure_vector = to_figure(figure)
    figure_symbol = figure_vector.pop
    color_figures = @board.display[color]

    figure_vector.each do |fig|
      fig = @board.figures[color][fig]
      next unless move_possible?(fig, row, column)

      @board.clear_position(fig.row, fig.column)
      fig.change_position(row, column)
      @board.change_position(row, column, color_figures[figure_symbol])
      kill(row, column) if enemy?(row, column)
    end
  end
end
