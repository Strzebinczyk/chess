# frozen_string_literal: true

require_relative 'board'

class Game
  attr_reader :board, :active_player

  def initialize
    @board = Board.new
    @active_player = :white
    @players = %i[white black]
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
    color = if @active_player == :white
              :black
            else
              :white
            end
    figure = board.find_figure(color, row, column)
    !figure.nil?
  end

  def no_obstacles?(path)
    # Get rid of starting spot
    path.shift
    # Get rid of ending point and return false if there is friendly figure on it
    last_tile = path.pop
    unless enemy?(last_tile[0], last_tile[1]) || @board.find_figure(@active_player, last_tile[0], last_tile[1]).nil?
      return false
    end

    path.each do |tile|
      unless @board.find_figure(:white, tile[0], tile[1]).nil? && @board.find_figure(:black, tile[0], tile[1]).nil?
        return false
      end
    end
    true
  end

  def valid_input?(input)
    start = input[0..1]
    stop = input[-2..]
    if ('a'..'h').include?(start[0]) && ('a'..'h').include?(stop[0]) && ('1'..'8').include?(start[1]) && ('1'..'8').include?(stop[1])
      return true
    end

    false
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

  def translate_position(string)
    column = { 'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7 }
    row = { '8' => 0, '7' => 1, '6' => 2, '5' => 3, '4' => 4, '3' => 5, '2' => 6, '1' => 7 }
    [row[string[1]], column[string[0]]]
  end

  def move(input)
    start = translate_position(input[0..1])
    stop = translate_position(input[-2..])
    figure = @board.find_figure(@active_player, start[0], start[1])
    return %i[error no_figure_on_start] if figure.nil?

    figure.update_possible_moves(@board) if figure.is_a?(Pawn)
    return %i[error move_not_possible] unless move_possible?(figure, stop[0], stop[1])

    path = compute_path(figure, start, stop)
    return %i[error obstacle] unless no_obstacles?(path)

    figure.change_position(stop[0], stop[1])
    kill(stop[0], stop[1]) if enemy?(stop[0], stop[1])
    :ok
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
