# frozen_string_literal: true

require_relative 'lib/game'

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

game = Game.new
render(game.board)
game.move(:black, 'pawn', 2, 5)
render(game.board)
