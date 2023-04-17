class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_accessor :score
  attr_reader :marker

  def initialize(marker)
    @marker = marker
    @score = 0
  end

  def scored
    @score += 1
  end

  def champion?
    @score == 5
  end
end

class TTTGame
  attr_reader :board, :human, :computer, :human_marker,
              :computer_marker, :first_to_move

  def initialize
    @human_marker = choose_marker
    @human = Player.new(human_marker)
    @computer_marker = computer_chooses_marker
    @board = Board.new
    @computer = Player.new(computer_marker)
    @first_to_move = starting_player
    @current_marker = first_to_move
  end

  def play
    clear
    display_welcome_message
    main_game
    display_goodbye_message
  end

  private

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def champion_loop
    loop do
      display_board
      player_move
      display_result
      press_enter_to_cont
      reset
      break if computer.champion? || human.champion?
    end
  end

  def main_game
    loop do
      champion_loop
      display_champion
      break unless play_again?
      reset
      display_play_again_message
    end
  end

  def starting_player
    first = ask_who_starts
    case first
    when 'P' then human_marker
    else computer_marker
    end
  end

  def ask_who_starts
    p_or_c = ['P', 'C']
    answer = ''
    loop do
      puts 'Who should play first? (P) for player (C) for computer.'
      answer = gets.chomp.upcase
      break if p_or_c.include?(answer)
      puts 'The only valid input is: C or P'
    end
    answer
  end

  def choose_marker
    puts 'Select a marker. It can be any single digit or letter'
    gets.chomp
  end

  def computer_chooses_marker
    o_or_zeros = ['0', 'o', 'O']
    if o_or_zeros.include?(human.marker)
      'X'
    else
      'O'
    end
  end

  def press_enter_to_cont
    puts 'Press enter to continue...'
    gets
  end

  def space
    puts ''
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    space
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_board
    puts "You're a #{@human_marker}. Computer is a #{computer_marker}"
    space
    puts 'The first to 5 wins is the winner.'
    space
    board.draw
    space
    display_score
    space
  end

  def joinor(arr, delimiter=', ', conj='or')
    case arr.size
    when 0..2 then arr.join(" #{conj} ")
    else
      arr[-1] = "#{conj} #{arr.last}"
      arr.join(delimiter)
    end
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_score
    puts "You're score is: #{human.score}"
    puts "The computer's score is: #{computer.score}"
  end

  def human_moves
    puts "Chose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    board[board.unmarked_keys.sample] = computer.marker
  end

  def human_turn?
    @current_marker == @human_marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer_marker
    else
      computer_moves
      @current_marker = @human_marker
    end
  end

  def display_champion
    if human.champion?
      puts "You're the Champion!"\
    else
      puts "The Computer is the Champion!"
    end
    space
  end

  def display_result
    scoring
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "Computer won!"
    else
      puts "It's a tie"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Sorry, must be y or n!"
    end

    answer == 'y'
  end

  def clear
    system 'clear'
  end

  def reset
    board.reset
    @current_marker = first_to_move
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    space
  end

  def scoring
    case board.winning_marker
    when human.marker
      human.scored
    when computer.marker
      computer.scored
    end
  end
end

game = TTTGame.new
game.play
