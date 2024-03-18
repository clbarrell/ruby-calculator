# Calculator class
class Calculator
  def self.add(number_one, number_two)
    number_one + number_two
  end

  def self.multiply(number_one, number_two)
    number_one * number_two
  end

  def self.main
    result_add = add(2, 3)
    result_multiply = multiply(4, 5)
    puts "Addition result for 2, 3: #{result_add}"
    puts "Multiplication result for 4, 5: #{result_multiply}"
  end
end

Calculator.main if __FILE__ == $PROGRAM_NAME
