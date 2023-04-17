class Card
  SUITS = ['Hearts', 'Clubs', 'Spades', 'Diamonds']
  FACE_VALUES = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace']

  attr_reader :face, :suit

  def initialize(suit, face)
    @suit = suit
    @face = face
  end

  def to_s
    "The #{face} of #{suit}"
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
  def show_hand
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
  include Hand

  attr_accessor :name, :cards

  def initialize
    @cards = []
    set_name
  end
end

class Player < Participant
  def set_name
    name = ''
    loop do
      puts "What's your name?"
      name = gets.chomp
      break unless name.empty?
      puts "Sorry, you must enter something, anything really."
    end
    self.name = name
  end

  def show_flop
    show_hand
  end
end

class Dealer < Participant
  ROBOTS = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5']

  def set_name
    self.name = ROBOTS.sample
  end

  def show_flop
    puts "---- #{name}'s Hand ----"
    puts cards.first
    puts " ?? "
    puts ''
  end
end

class TwentyOne
  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def reset
    self.deck = Deck.new
    player.cards = []
    dealer.cards = []
  end

  def deal_cards
    2.times do
      player.add_card(deck.deal_one)
      dealer.add_card(deck.deal_one)
    end
  end

  def show_flop
    clear
    player.show_flop
    dealer.show_flop
  end

  def player_answer
    answer = ''
    loop do
      answer = gets.chomp.downcase
      break if ['h', 's'].include?(answer)
      puts "Sorry must enter 'h' or 's'."
    end
    answer
  end

  def hit_or_stay
    loop do
      puts "Would you like to (h)it or (s)tay?"
      answer = player_answer

      if answer == 's'
        puts "#{player.name} stays!"
        break
      elsif player.busted?
        break
      else
        player.add_card(deck.deal_one)
        puts "#{player.name} hits!"
        show_flop
        break if player.busted?
      end
    end
  end

  def player_turn
    puts "#{player.name}'s turn..."
    hit_or_stay
  end

  def dealer_hit_or_stay
    loop do
      break if dealer.busted?
      if dealer.total >= 17
        puts "#{dealer.name} stays!"
        break
      else
        dealer.add_card(deck.deal_one)
        show_cards
        puts "#{dealer.name} hits!"
      end
    end
  end

  def dealer_turn
    puts "#{dealer.name}'s turn..."
    dealer_hit_or_stay
  end

  def show_busted
    if player.busted?
      puts "It looks like #{player.name} busted! #{dealer.name} wins!"
    elsif dealer.busted?
      puts "It looks like #{dealer.name} busted! #{player.name} wins!"
    end
  end

  def show_cards
    clear
    player.show_hand
    dealer.show_hand
  end

  def show_result
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

    answer == 'y'
  end

  def clear
    system 'clear'
  end

  def start
    loop do
      clear
      deal_cards
      show_flop

      player_turn
      if player.busted?
        show_busted
        break unless play_again?
        reset
        next
      end

      dealer_turn
      if dealer.busted?
        show_busted
        break unless play_again?
        reset
        next
      end

      show_cards
      show_result
      play_again? ? reset : break
    end

    puts "Thank you for playing Twenty-One. Goodbye!"
  end
end

game = TwentyOne.new
game.start
