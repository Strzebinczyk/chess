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

def input_figure(game)
  puts 'Please enter the figure you want to move'
  figure = gets.chomp.downcase
  until game.valid_figure?(figure)
    puts 'Please enter a valid figure'
    puts 'You can choose from pawn, rook, bishop, knight, queen and king'
    figure = gets.chomp.downcase
  end
  figure
end

def input_num
  num = gets.chomp.to_i
  until (0..7).include?(num)
    puts 'Please enter a valid number, it has to be between 0 and 7'
    num = gets.chomp.to_i
  end
  num
end

game = Game.new
loop do
  render(game.board)
  puts "Active player is #{game.active_player}"
  figure = input_figure(game)
  puts 'Please enter the row you want to move to'
  row = input_num
  puts 'Please enter the column you want to move to'
  column = input_num
  case game.move(figure, row, column)
  in :ok
    if game.checkmate?
      puts 'checkmate'
      puts "Congratulations, #{game.active_player}"
      break
    end
    puts 'Check' if game.check?
    game.change_active_player
  in [:error, :move_not_possible]
    puts 'Move not possible, please retry'
    redo
  in [:error, :obstacle]
    puts 'Other figures in the way, please retry'
    redo
  end
end
