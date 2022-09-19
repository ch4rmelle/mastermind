module GameHelpers
  def intro
    puts 'Welcome to Mastermind! Ready for a code-breaking challenge?' \
    "\nTest the computer's code-breaking skills or your own." \
    "\n\nYou have 2 options: 1) Be a #{'CODE-MAKER'.red} or 2) Be a " \
   "#{'CODE-BREAKER'.blue}  \n\n#{'CODE-MAKER'.red} - Make up a 4 digit combination" \
   ' and have the computer guess it in 12 turns or less.' \
   "\n\n#{'CODE-BREAKER'.blue} - The computer chooses a 4 digit combination" \
   ' and you try to guess it in 12 turns or less.' \
   "\nPlayer will receive feedback after each turn:\n" \
   "\t#{'●'.green} = Correct number and correct position\n"\
   "\t○ = Correct number but wrong position\n"
  end

  def clear_console
    sleep 1
    system('clear')
  end

  def display_feedback(num_pos, num)
    num_pos.times do
      print '● '.green
    end
    num.times do
      print '○ '
    end
  end
end

class String
  def green
    "\e[32m#{self}\e[0m"
  end

  def red
    "\e[31m#{self}\e[0m"
  end

  def blue
    "\e[34m#{self}\e[0m"
  end

  def magenta
    "\e[35m#{self}\e[0m"
  end

  def bold
    "\e[1m#{self}\e[22m"
  end
end

class Game
  include GameHelpers
  def initialize
    @comp = Computer.new
    @human = Human.new
    @correct_num_position = 0
    @correct_num = 0
    @rounds = 1
    intro
  end

  def user_choice
    puts "\nEnter your choice: 1) Be a #{'CODE-MAKER'.red} 2) Be a " \
    "#{'CODE-BREAKER'.blue}  "
    while true
      choice = gets.chomp.to_i
      break if choice.between?(1, 2)

      puts 'Invalid input!'
    end
    choice
  end

  def play
    choice = user_choice
    @human.player_name
    clear_console
    case choice
    when 1
      codemaker_play
    when 2
      @combo = @comp.generate_combo
      codebreaker_loop(@combo)
    end
  end

  def valid_input?(input)
    input.all? { |x| x.between?(1, 6) } && input.length == 4
  end

  protected

  def codebreaker_loop(combo) # find a way to make this shorter
    while @rounds <= 12
      puts "\n\n#{'ROUND:'.magenta.bold} #{@rounds}"
      user_combo = @human.prompt_user_combo
      if match?(@combo, user_combo)
        puts 'You cracked the code!'; return
      end
      if valid_input?(user_combo)
        codebreaker_play(user_combo, @combo)
      else
        puts "\nInvalid input! Enter a number between 1-6"
      end
    end
    puts "You lost! The secret code was #{@combo.join}"
    play_again?
  end

  def codebreaker_play(user_combo, combo)
    check_combinations(user_combo, combo)
    display_feedback(@correct_num_position, @correct_num)
    @rounds += 1
    reset_counter
  end
end

def reset_counter
  @correct_num_position = 0
  @correct_num = 0
end

def check_combinations(user_combo, combo)
  user_combo.each_index do |i|
    if user_combo[i].to_i == combo[i]
      @correct_num_position += 1
    elsif combo.include?(user_combo[i])
      @correct_num += 1
    end
  end
end

def match?(user_combo, combo)
  true if user_combo == combo
end

def play_again?
  puts 'Play again? (Y/N)'
  input = gets.chomp.upcase
  if input == 'Y'
    @rounds = 0
    play
  end
  exit
end

class Human
  attr_accessor :name

  def initialize
    @name = ''
  end

  def player_name
    puts 'Please enter your name:'
    @name = gets.chomp
    @name
  end

  def prompt_user_combo
    puts "\n#{@name.blue}, please enter a 4 digit combination (1-6):"
    gets.chomp.split('').map(&:to_i)
  end
end

# class Computer
class Computer
  attr_accessor :name

  def initialize
    @combo = []
    @name = 'Computer'
  end

  def generate_combo
    4.times do
      @combo << (rand * 6 + 1).floor
    end
    @combo
  end
end

game = Game.new
game.play
