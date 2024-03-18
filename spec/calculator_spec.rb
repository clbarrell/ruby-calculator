require 'calculator'

RSpec.describe Calculator do
  describe '.add' do
    it 'adds two numbers correctly' do
      expect(Calculator.add(5, 4)).to eq(9)
    end

    it 'adds negative numbers' do
      expect(Calculator.add(-1, -1)).to eq(-2)
    end
  end
end
