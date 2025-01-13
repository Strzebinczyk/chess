# frozen_string_literal: true

require_relative 'figure'

class King < Figure # rubocop:disable Style/Documentation
  def display
    return '♛' if @color == :white

    '♕'
  end

  def move_pattern
    [[1, 0], [1, 1], [0, 1], [0, -1], [-1, -1], [-1, 0], [-1, 1], [1, -1]]
  end
end
