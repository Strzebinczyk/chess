# frozen_string_literal: true

require_relative 'figure'

class Bishop < Figure # rubocop:disable Style/Documentation
  def display
    return '♝' if @color == :white

    '♗'
  end

  def move_pattern
    [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
     [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
     [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7],
     [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7]]
  end
end
