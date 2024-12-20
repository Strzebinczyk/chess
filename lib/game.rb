# frozen_string_literal: true

require_relative 'board'

class Game
  attr_reader :board, :active_player

  def initialize
    @board = Board.new
    @active_player = :white
    @players = %i[white black]
  end

  def valid_input?(move)
    regex = /^[a-h][1-8].*[a-h][1-8]$/
    regex.match?(move)
  end

  def move(input)
    start = translate_position(input[0..1])
    stop = translate_position(input[-2..])
    figure = @board.find_figure(start)
    return %i[error no_figure_on_start] if figure.nil?

    return %i[error move_not_possible] unless move_possible?(figure, stop)

    path = compute_path(figure, start, stop)
    return %i[error obstacle] unless no_obstacles?(path)

    kill(stop) if enemy?(stop)
    figure.change_position(stop)
    :ok
  end

  def check?
    enemy_king_position = [enemy_king.row, enemy_king.column]
    figures = @board.figures[@active_player]
    figures.each_value do |figure|
      path = compute_path(figure, [figure.row, figure.column], enemy_king_position)
      next unless no_obstacles?(path)
      return true if @board.find_possible_moves(figure).include?(enemy_king_position)
    end
    false
  end

  def checkmate?
    check? &&
      enemy_king.possible_moves.none? { |move| move_possible?(enemy_king, move[0], move[1]) }
  end

  def change_active_player
    @active_player = inactive_player
  end

  private

  def inactive_player
    if @active_player == :white
      :black
    else
      :white
    end
  end

  def enemy_king
    @board.figures[inactive_player][:king]
  end

  def move_possible?(figure, position)
    possible_moves = @board.find_possible_moves(figure)

    possible_moves.include?(position)
  end

  def kill(position)
    board.kill(position)
  end

  def translate_position(string)
    column = { 'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7 }
    row = { '8' => 0, '7' => 1, '6' => 2, '5' => 3, '4' => 4, '3' => 5, '2' => 6, '1' => 7 }
    [row[string[1]], column[string[0]]]
  end

  def compute_path(figure, start, stop)
    path = [start]
    # knight jumps, so his path is only a starting and stopping point
    if figure.is_a?(Knight)
      path.push(stop)
      return path
    end
    current = start
    rows = stop[0] - start[0]
    columns = stop[1] - start[1]
    # move horizontally to the right
    if rows.zero? && columns.positive?
      until current == stop
        current = [current[0], (current[1] + 1)]
        path.push(current)
      end
    # move horizontally to the left
    elsif rows.zero? && columns.negative?
      until current == stop
        current = [current[0], (current[1] - 1)]
        path.push(current)
      end
    # move vertically up
    elsif rows.positive? && columns.zero?
      until current == stop
        current = [(current[0] + 1), current[1]]
        path.push(current)
      end
    # move vertically down
    elsif rows.negative? && columns.zero?
      until current == stop
        current = [(current[0] - 1), current[1]]
        path.push(current)
      end
    # move diagonally up and right
    elsif rows.positive? && columns.positive?
      until current == stop
        current = [(current[0] + 1), (current[1] + 1)]
        path.push(current)
      end
    # move diagonally up and left
    elsif rows.positive? && columns.negative?
      until current == stop
        current = [(current[0] + 1), (current[1] - 1)]
        path.push(current)
      end
    # move diagonally down and right
    elsif rows.negative? && columns.positive?
      until current == stop
        current = [(current[0] - 1), (current[1] + 1)]
        path.push(current)
      end
    # move diagonally down and left
    elsif rows.negative? && columns.negative?
      until current == stop
        current = [(current[0] - 1), (current[1] - 1)]
        path.push(current)
      end
    end
    path
  end

  def enemy?(position)
    color = inactive_player
    figure = board.find_figure(position)
    !figure.nil? && figure.color == color
  end

  def no_obstacles?(figure_path)
    # Get rid of starting spot
    path = figure_path[1..]
    # Get rid of ending point and return false if there is friendly figure on it
    last_tile = path.pop
    return false unless enemy?([last_tile[0], last_tile[1]]) || @board.find_figure([last_tile[0], last_tile[1]]).nil?

    return true if path.all? { |tile| @board.find_figure([tile[0], tile[1]]).nil? }

    false
  end
end

game = Game.new
game.move('c2 to c3')
game.move('d7 to d5')
game.move('b2 to b4')
puts game.check?
game.move('e8 to a4')
puts check?
