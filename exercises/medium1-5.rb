class Minilang
  COMMANDS = ['PUSH', 'ADD', 'SUB', 'MULT', 'DIV',
              'MOD', 'POP', 'PRINT']
  @@counter = 0
  attr_accessor :register
  attr_reader :commands, :stack

  def initialize(commands)
    @commands = commands.split
    @register = 0
    @stack = []
    @@counter += 1
    puts "This is Minilang: #{@@counter}"
  end

  def eval(commands)
    commands.each do |command|
      if command =~ /\A[-+]?\d+\z/ 
        next
      elsif !COMMANDS.include?(command)
        raise InvalidToken.new("Invalid token #{command}")
      end
    end
  end


  def read_commmands
    eval(commands)
    register = @register
    commands.each do |command|
      case
      when command == 'PUSH'
        stack << register
      when command == 'ADD'
        register += stack.pop
      when command == 'SUB'
        register -= stack.pop
      when command == 'MULT'
        register *= stack.pop
      when command == 'DIV'
        register /= stack.pop
      when command == 'MOD'
        register %= stack.pop
      when command == 'POP' && !stack.empty?
        register = stack.pop
      when command == 'POP' && stack.empty?
        register = nil
      when command == 'PRINT' && register != nil
        puts register
      when command == 'PRINT' && register == nil
        puts 'Empty stack!'
      else   register = command.to_i
      end
    end
  end
end

class InvalidToken < StandardError

end

#write a method for each command 


Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval#1
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval#2
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval#3
# # 8

Minilang.new('6 PUSH').eval#4
#(nothing printed; no PRINT commands)

Minilang.new('PRINT').eval# 5
# # 0

Minilang.new('5 PUSH 3 MULT PRINT').eval#6
# # 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval#7
# # 5
# # 3
# # 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval#8
# # 10
# # 5

Minilang.new('5 PUSH POP POP PRINT').eval#9
# # Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval#10
# 6