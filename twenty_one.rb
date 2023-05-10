module Systemable
  def clear
    system 'clear'
  end

  def wait_for_2_seconds
    sleep(2)
  end
end

module Displayable
  def display_dealer_turn
    puts "#{dealer.name}'s turn..."
  end

  def display_dealer_reveal
    puts "#{dealer.name} reveals."
  end

  def display_player_busted
    puts "It looks like #{player.name} busted! #{dealer.name} wins!"
  end

  def display_dealer_busted
    puts "It looks like #{dealer.name} busted! #{player.name} wins!"
  end

  def display_player_win
    puts "It looks like #{player.name} wins!"
  end

  def display_dealer_win
    puts "It looks like #{dealer.name} wins!"
  end

  def display_tie
    puts "It looks like it's a tie."
  end

  def display_wrong_h_or_s_input
    puts "Sorry must enter 'h' or 's'."
  end

  def display_hits
    puts "#{name} hits!"
  end

  def display_stays
    puts "#{name} stays!"
  end

  def display_total
    puts "=> Total: #{total}"
    puts ''
  end

  def display_name_hand
    puts "---- #{name}'s Hand ----"
  end

  def display_goodbye
    puts "Thank you for playing Twenty-One. Goodbye!"
  end

  def display_y_or_n
    puts "Sorry, must be 'y' or 'n'."
  end

  def display_enter_anything
    puts "Sorry, you must enter something, anything really."
  end

  def display_dealer_hand
    puts "---- #{name}'s Hand ----"
    puts cards.first
    puts " ?? "
    puts ''
  end
end

module Questionable
  def display_whats_your_name
    puts "What's your name?"
  end

  def display_play_again
    puts "Would you like to play again? (y/n)"
  end

  def display_h_or_s
    puts "It's your turn."
    puts "Would you like to hit or stay?"
    puts "Enter 'h' for hit and 's' for stay."
  end
end

class Card
  SUITS = ['Hearts', 'Clubs', 'Spades', 'Diamonds']
  FACE_VALUES = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace']

  attr_reader :face, :suit

  def initialize(suit, face)
    @suit = suit
    @face = face
  end

  def to_s
    "#{face} of #{suit}"
  end

  def ace?
    face == 'Ace'
  end

  def royalty?
    face == 'King' || face == 'Queen' || face == 'Jack'
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      Card::FACE_VALUES.each do |card|
        @cards << Card.new(suit, card)
      end
    end

    shuffle_deck!
  end

  def shuffle_deck!
    cards.shuffle!
  end

  def deal_one
    cards.pop
  end
end

module Hand
  BUSTED_TOTAL = 21
  def hand
    display_name_hand
    cards.each do |card|
      puts "=> #{card}"
    end
    display_total
  end

  def count_values(cards)
    total = 0
    cards.each do |card|
      total += if card.ace?        then 11
               elsif card.royalty? then 10
               else card.face
               end
    end
    total
  end

  def total
    total = count_values(cards)
    cards.select(&:ace?).count.times do
      break if total <= BUSTED_TOTAL
      total -= 10
    end
    total
  end

  def add_card(new_card)
    cards << new_card
  end

  def busted?
    total > BUSTED_TOTAL
  end
end

class Participant
  include Hand, Systemable, Displayable, Questionable

  attr_accessor :name, :cards

  def initialize
    @cards = []
    set_name
  end

  def stays
    display_stays
    wait_for_2_seconds
  end

  def hits(deck)
    display_hits
    wait_for_2_seconds
    add_card(deck.deal_one)
  end
end

class Player < Participant
  def set_name
    clear
    name = ''
    loop do
      display_whats_your_name
      name = gets.strip.chomp
      break unless name.empty?
      clear
      display_enter_anything
    end
    self.name = name.capitalize
  end

  def show_hand
    hand
  end

  def ask_for_h_or_s
    answer = ''
    loop do
      answer = gets.chomp.downcase
      break if ['h', 's'].include?(answer)
      display_wrong_h_or_s_input
    end
    answer
  end
end

class Dealer < Participant
  STAYS_TOTAL = 17
  ROBOTS = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5']

  def show_hand
    display_dealer_hand
  end

  def finished?(deck)
    if total >= STAYS_TOTAL
      stays
      return true
    else
      hits(deck)
    end
    false
  end

  def hits(deck)
    display_hits
    wait_for_2_seconds
    add_card(deck.deal_one)
  end

  private

  def set_name
    self.name = ROBOTS.sample
  end
end

class TwentyOne
  include Systemable, Displayable, Questionable
  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    main_game_loop

    display_goodbye
  end

  private

  def main_game_loop
    loop do
      opening

      player_hand = player_hand_results
      if player_hand != 1; player_hand == 2 ? break : next end

      dealer_hand =  dealer_hand_results
      if dealer_hand != 1; dealer_hand == 2 ? break : next end

      show_result
      break unless play_again?
    end
  end

  def opening
    clear
    deal_cards
    show_flop
  end

  def deal_cards
    2.times do
      player.add_card(deck.deal_one)
      dealer.add_card(deck.deal_one)
    end
  end

  def show_flop
    clear
    player.show_hand
    dealer.show_hand
  end

  def reset
    self.deck = Deck.new
    player.cards = []
    dealer.cards = []
  end

  def player_hand_results
    player_turn
    return 1 unless player.busted?
    show_busted
    return 3 if play_again?
    2
  end

  def player_turn
    loop do
      display_h_or_s
      answer = player.ask_for_h_or_s
      break if command(answer)
    end
  end

  def command(input)
    show_flop
    if input == 's'
      player.stays
      return true
    else
      player.hits(deck)
      show_flop
    end
    player.busted? == true
  end

  def dealer_hand_results
    dealer_turn
    return 1 unless dealer.busted?
    show_busted
    return 3 if play_again?
    2
  end

  def dealer_turn
    display_dealer_turn
    wait_for_2_seconds
    dealer_hit_or_stay
  end

  def dealer_hit_or_stay
    dealer_reveal
    wait_for_2_seconds
    loop do
      show_cards
      break if dealer.busted?
      break if dealer.finished?(deck)
    end
  end

  def dealer_reveal
    show_cards
    display_dealer_reveal
  end

  def show_cards
    clear
    player.hand
    dealer.hand
  end

  def show_busted
    if player.busted?
      display_player_busted
    elsif dealer.busted?
      display_dealer_busted
    end
  end

  def show_result
    show_cards
    if player.total > dealer.total
      display_player_win
    elsif player.total < dealer.total
      display_dealer_win
    else
      display_tie
    end
  end

  def play_again?
    answer = nil
    loop do
      display_play_again
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      display_y_or_n
    end
    reset
    answer == 'y'
  end
end

game = TwentyOne.new
game.start
