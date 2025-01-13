# frozen_string_literal: true

require 'yaml'
require_relative 'board'

class Game # rubocop:disable Metrics/ClassLength,Style/Documentation
  attr_reader :board, :active_player

  def initialize
    @board = Board.new
    @active_player = :white
    @players = %i[white black]
  end

  def valid_input?(move)
    regex = /^[a-h][1-8].*[a-h][1-8]$/
    regex.match?(move) || move == 'save'
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
      figure_position = [figure.row, figure.column]
      next unless move_possible?(figure, enemy_king_position)

      path = compute_path(figure, figure_position, enemy_king_position)
      next unless no_obstacles?(path)

      return true
    end
    false
  end

  def checkmate? # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    return false unless check?

    figures = @board.figures[@active_player]
    @board.find_possible_moves(enemy_king).none? do |move|
      enemy_king_path = compute_path(enemy_king, enemy_king.position, move)
      return false unless no_obstacles?(enemy_king_path)

      figures.each_value do |figure|
        return true unless move_possible?(figure, enemy_king.position)

        path = compute_path(figure, figure.position, enemy_king.position)
        return false if no_obstacles?(path)
      end
    end
  end

  def change_active_player
    @active_player = inactive_player
  end

  def load_game(name)
    filename = "saves/#{name}.yml"
    yaml = YAML.load_file(filename, permitted_classes: [Symbol, Board, Rook, King, Bishop, Knight, Queen, Pawn])
    @board = yaml[:board]
    @active_player = yaml[:active_player]
    @players = yaml[:players]
  end

  def save_game(name)
    Dir.mkdir('saves') unless Dir.exist?('saves')
    filename = "saves/#{name}.yml"
    variables = { board: @board, active_player: @active_player, players: @players }
    File.write(filename, variables.to_yaml)
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

  def compute_path(figure, start, stop) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
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
