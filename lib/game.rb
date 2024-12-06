require_relative 'board'

class Game
  attr_reader :board

  def initialize
    @board = Board.new
    @active_player = :white
    @players = %i[white black]
  end

  def to_figure(string)
    figures = { 'rook' => %i[rook1 rook2 rook], 'knight' => %i[knight1 knight2 knight], 'bishop' => %i[bishop1 bishop2 bishop],
                'king' => [:king], 'queen' => [:queen], 'pawn' => %i[pawn1 pawn2 pawn3 pawn4 pawn5 pawn6 pawn7 pawn8 pawn] }
    figures[string]
  end

  def compute_path(figure, start, stop)
    queue = [[start, [start]]]
    visited = Array.new(8) { Array.new(8, false) }

    until queue.length == 0
      # Visit the next queued position and update array of visited cells
      current, history = queue.shift
      visited[current[0]][current[1]] = true
      figure.change_position(current[0], current[1])
      # if stopping point is reached return history of moves
      if current == stop
        figure.change_position(start[0], start[1])
        return history
      end

      # for all possible moves if the target cell is not yet visited add them to the queue with their corresponding move history
      figure.possible_moves.each do |destination|
        queue.push([destination, history + [destination]]) unless visited[destination[0]][destination[1]]
      end
    end
  end

  def enemy?(row, column)
    enemy = if @active_player == :white
              @board.display[:black]
            else
              @board.display[:white]
            end
    enemy.include?(@board.positions[row][column])
  end

  # not finished
  def no_obstacles?(figure, path)
    # Get rid of starting spot
    path.shift
    # Get rid of ending point and return false if there is friendly figure on it
    tile = path.pop
    return false unless enemy?(tile[0], tile[1]) || @board.positions[tile[0]][tile[1]].nil?
    return false if path.pop

    path.each do |tile|
      return false unless @board.positions[tile[0]][tile[1]].nil?
    end
    true
  end

  def move_possible?(figure, row, column)
    possible_moves = figure.possible_moves
    return false if possible_moves.nil?

    path = compute_path(figure, [figure.row, figure.column], [row, column])
    return true if possible_moves.include?([row, column]) && no_obstacles?(figure, path)

    false
  end

  def move(color = @active_player, figure, row, column)
    figure_vector = to_figure(figure)
    figure_symbol = figure_vector.pop
    color_figures = @board.display[color]

    figure_vector.each do |figure|
      figure = @board.figures[color][figure]
      next unless move_possible?(figure, row, column)

      path = compute_path(figure, [figure.row, figure.column], [row, column])
      @board.clear_position(figure.row, figure.column)
      figure.change_position(row, column)
      @board.change_position(row, column, color_figures[figure_symbol])
    end
  end
end
