module Systemable
  def clear
    system 'clear'
  end

  def press_enter
    puts "Please press enter to continue."
    gets
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
  def hand
    puts "---- #{name}'s Hand ----"
    cards.each do |card|
      puts "=> #{card}"
    end
    puts "=> Total: #{total}"
    puts ''
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
      break if total <= 21
      total -= 10
    end
    total
  end

  def add_card(new_card)
    cards << new_card
  end

  def busted?
    total > 21
  end
end

class Participant
  include Hand, Systemable

  attr_accessor :name, :cards

  def initialize
    @cards = []
    set_name
  end

  def stays
    puts "#{name} stays!"
    press_enter
  end

  def hits(deck)
    puts "#{name} hits!"
    press_enter
    add_card(deck.deal_one)
  end
end

class Player < Participant
  def set_name
    clear
    name = ''
    loop do
      puts "What's your name?"
      name = gets.chomp
      break unless name.empty?
      clear
      puts "Sorry, you must enter something, anything really."
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
      puts "Sorry must enter 'h' or 's'."
    end
    answer
  end
end

class Dealer < Participant
  ROBOTS = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5']

  def show_hand
    puts "---- #{name}'s Hand ----"
    puts cards.first
    puts " ?? "
    puts ''
  end

  def finished?(deck)
    if total >= 17
      stays
      return true
    else
      hits(deck)
    end
    false
  end

  private

  def set_name
    self.name = ROBOTS.sample
  end
end

class TwentyOne
  include Systemable
  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    main_game_loop

    puts "Thank you for playing Twenty-One. Goodbye!"
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
      puts "It's your turn."
      puts "Would you like to hit or stay?"
      puts "Enter 'h' for hit and 's' for stay."
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
    puts "#{dealer.name}'s turn..."
    dealer_hit_or_stay
  end

  def dealer_hit_or_stay
    dealer_reveal
    press_enter
    loop do
      show_cards
      break if dealer.busted?
      break if dealer.finished?(deck)
    end
  end

  def dealer_reveal
    show_cards
    puts "#{dealer.name} reveals."
  end

  def show_cards
    clear
    player.hand
    dealer.hand
  end

  def show_busted
    if player.busted?
      puts "It looks like #{player.name} busted! #{dealer.name} wins!"
    elsif dealer.busted?
      puts "It looks like #{dealer.name} busted! #{player.name} wins!"
    end
  end

  def show_result
    show_cards
    if player.total > dealer.total
      puts "It looks like #{player.name} wins!"
    elsif player.total < dealer.total
      puts "It looks like #{dealer.name} wins!"
    else
      puts "It's a tie"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      puts "Sorry, must be 'y' or 'n'."
    end
    reset
    answer == 'y'
  end
end

game = TwentyOne.new
game.start
