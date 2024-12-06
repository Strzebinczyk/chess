# frozen_string_literal: true

module Figure
  def find_possible_moves
    result = []
    @move_pattern.each do |option|
      row = @row + option[0]
      column = @column + option[1]
      if (row in 0..7) && (column in 0..7)
        result.push([row, column])
      end
    end
    result
  end

  def change_position(row, column)
    @row = row
    @column = column
  end
end
