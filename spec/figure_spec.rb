# frozen_string_literal: true

require_relative '../lib/figures/figure'

describe Figure do
  subject(:figure) { described_class.new(:white, 5, 2) }

  describe '#change_position' do
    it 'changes the row' do
      figure.change_position([2, 2])
      expect(figure.row).to be 2
    end

    it 'changes the column' do
      figure.change_position([2, 5])
      expect(figure.column).to be 5
    end
  end

  describe '#position' do
    it "returns figure's position" do
      expect(figure.position).to eql [5, 2]
    end
  end
end
