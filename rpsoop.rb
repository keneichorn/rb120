module Scoreable
  attr_accessor :score

  def scored
    @score += 1
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end
end

class Human < Player
  include Scoreable
  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?

      puts 'Sorry, must enter a value'
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts 'Please choose rock, paper, or scissors:'
      choice = gets.chomp
      break if Move::VALUES.include? choice

      puts 'Sorry, invalid choice.'
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  include Scoreable
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    (rock? &&  other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
  end

  def to_s
    @value
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    system 'clear'
    ["Welcome #{human.name.capitalize}!",
     "to Rock, Paper, Scissors!",
     "Press enter for the rules..."].each { |line| puts line.center(80) }
    gets
  end

  def display_rules_message
    system 'clear'
    ["The rules are straight forward:",
     "Rock beats Scissors, Paper beats Rock, Scissors beats Paper",
     "If you beat the #{computer.name}, you will score 1 point",
     "If the #{computer.name} beats you, they will score 1 point",
     "The first player to reach 10 points wins",
     "press enter to continue..."].each { |line| puts line.center(80) }
    gets
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Good Bye!"
  end

  def display_moves
    puts "#{human.name} chose: #{human.move}."
    puts "The #{computer.name} chose: #{computer.move}"
  end

  def winner
    if human.move > computer.move
      human.scored
      human
    elsif human.move < computer.move
      computer.scored
      computer
    end
  end

  def display_winner
    case winner
    when human
      puts "#{human.name} won!"
    when computer
      puts "#{computer.name} won!"
    else puts "It's a tie!"
    end
  end

  def grand_winner
    
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n."
    end
    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end

  def display_score
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
  end

  def main_loop
    display_rules_message
    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      display_score
      break if human.score == 10 || computer.score == 10
    end
  end

  def play
    display_welcome_message
    loop do
      main_loop

      break unless play_again?
    end

    display_goodbye_message
  end
end

RPSGame.new.play
