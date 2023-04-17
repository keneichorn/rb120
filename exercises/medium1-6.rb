class GuessingGame
  attr_accessor :guesses
  attr_reader :number
  def initialize
    @number = (1..100).to_a.sample
    @guesses = 7
  end

  def play
    loop do
      if guesses == 0
        puts "You have no more guesses. You lost!"
        break
      end
      break if guess == number
      self.guesses -= 1
    end
  end

  def guess
    puts "You have #{guesses} guesses remaining."
    puts "Enter a number between 1 and 100:"
    answer = nil
    loop do
      answer = gets.chomp.to_i
      break if (1..100).to_a.include?(answer)
      puts "Invalid guess. Enter a number between 1 and 100:"
    end
    is_correct_guess(answer)
    answer
  end

  def is_correct_guess(answer)
    if answer == number
      puts "That's the number!"
    elsif answer > number
      puts "Your guess is too high."
    elsif answer < number
      puts "Your guess is too low."
    end
    puts ''
  end

end


game = GuessingGame.new
game.play
think of a way to make this problem more classy
you have the knowledge, think of variables other than
local or instance