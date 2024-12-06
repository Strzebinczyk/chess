# frozen_string_literal: true

require_relative 'lib/board'

def render(board)
  puts '   +----+----+----+----+----+----+----+----+'
  board.positions.each_index do |row|
    print "#{row}  "
    board.positions[row].each_index do |column|
      if board.positions[row][column].nil?
        print '|    '
      else
        print "| #{board.positions[row][column]}  "
      end
    end
    puts '|'
    puts '   +----+----+----+----+----+----+----+----+'
  end

  print '   '
  (0..7).each { |letter| print "  #{letter}  " }
  puts ''
end

board = Board.new
render(board)
board.move(:black, 'pawn', 2, 5)
render(board)
