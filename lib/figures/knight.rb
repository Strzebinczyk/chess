# frozen_string_literal: true

require_relative 'figure'

class Knight < Figure # rubocop:disable Style/Documentation
  def display
    return '♞' if @color == :white

    '♘'
  end

  def move_pattern
    [[-2, -1], [-2, 1], [2, -1], [2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2]]
  end
end
