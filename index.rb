# frozen_string_literal: true

require_relative 'lib/game'

def render(board)
  hash = board.display
  positions = Array.new(8) { Array.new(8, nil) }
  hash.each do |position, symbol|
    positions[position[0]][position[1]] = symbol
  end
  rows = [8, 7, 6, 5, 4, 3, 2, 1]
  puts '   +----+----+----+----+----+----+----+----+'
  positions.each_index do |row|
    print "#{rows[row]}  "
    positions[row].each_index do |column|
      if positions[row][column].nil?
        print '|    '
      else
        print "| #{positions[row][column]}  "
      end
    end
    puts '|'
    puts '   +----+----+----+----+----+----+----+----+'
  end

  print '   '
  ('a'..'h').each { |letter| print "  #{letter}  " }
  puts ''
end

def input(game)
  puts "Please enter the move you want to make, for example: 'a1 to h1'"
  input = gets.chomp.downcase
  until game.valid_input?(input)
    puts 'Please enter a valid move'
    input = gets.chomp.downcase
  end
  input
end

game = Game.new
loop do
  render(game.board)
  puts "Active player is #{game.active_player}"
  input = input(game)
  case game.move(input)
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
