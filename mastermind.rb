module Display
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

  def prompt_secret_code
    puts 'Enter a 4 a digit code for the computer to guess:'
  end

  def prompt_game_choice
    puts "\nEnter your choice: 1) Be a #{'CODE-MAKER'.red} 2) Be a " \
    "#{'CODE-BREAKER'.blue}  "
  end

  def play_again_text
    puts 'Play again? (Y/N)'
  end

  def prompt_player_name
    puts 'Please enter your name:'
  end

  def prompt_guess
    puts "\n#{@name.blue}, please enter a 4 digit combination (1-6):"
  end

  def display_feedback(num_pos, num)
    print 'Clues: '
    num_pos.times do
      print '● '.green
    end
    num.times do
      print '○ '
    end
  end

  def clear_console
    sleep 1
    system('clear')
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
  include Display
  def initialize
    @code_breaker = CodeBreaker.new
  end

  def user_choice
    prompt_game_choice
    while true
      choice = gets.chomp.to_i
      break if choice.between?(1, 2)

      puts 'Invalid input!'
    end
    choice
  end

  def play
    intro
    choice = user_choice
    case choice
    when 1
      codemaker_play
    when 2
      @code_breaker.play
    end
  end
end

class CodeBreaker
  include Display

  @@rounds = 1
  def initialize
    @human = Human.new
    @comp = Computer.new
    @win = false
    @correct_num_position = 0
    @correct_num = 0
  end

  def play
    @human.player_name
    @secret_code = @comp.generate_code
    clear_console
    play_loop
    result_message
  end

  def check_guess(user_guess, combo)
    user_guess.each_index do |i|
      if user_guess[i].to_i == combo[i]
        @correct_num_position += 1
      elsif combo.include?(user_guess[i])
        @correct_num += 1
      end
    end
  end

  def play_loop
    while @@rounds <= 12
      display_round
      user_guess = @human.prompt_user_guess
      if valid_input?(user_guess)
        return if win?(user_guess, @secret_code)

        codebreaker_logic(user_guess, @secret_code)
      else
        puts "\n Invalid input! Try again."
      end
    end
  end

  protected

  def reset_feedback_counter
    @correct_num_position = 0
    @correct_num = 0
  end

  def reset_rounds
    @@rounds = 0
  end

  def codebreaker_logic(user_guess, secret_code)
    check_guess(user_guess, secret_code)
    display_feedback(@correct_num_position, @correct_num)
    reset_feedback_counter
    @@rounds += 1
  end

  def display_round
    puts "\n\n#{'ROUND:'.magenta.bold} #{@@rounds}"
  end

  def win?(user_guess, code)
    @win = user_guess == code
  end

  def result_message
    if @win
      puts "\nAmazing! You solved the secret code."
    else
      puts "\nYou lost :( The Secret Code was #{@secret_code.join(' ').green}"
    end
  end

  def valid_input?(input)
    input.all? { |x| x.between?(1, 6) } && input.length == 4
  end
end

class CodeMaker
  include Display

  def initialize
    @human = Human.new
    @comp = Comp.new
    @correct_num_position = 0
    @correct_num = 0
    @possible_combos = ([1, 2, 3, 4, 5, 6] * 4).combination(4).to_a.uniq.sort
    @comp_feedback = []
    @combo_feedback = []
  end

  def play
    @human.player_name
    secret_code = @human.prompt_secret_code
    codemaker_logic(secret_code)
  end

  def codemaker_logic(secret_code)


  end

end

class Human
  include Display
  attr_accessor :name

  def initialize
    @name = ''
  end

  def player_name
    prompt_player_name
    @name = gets.chomp
  end

  def prompt_user_guess
    puts "#{@name.blue}, enter a 4 digit number (between 1-6)"
    gets.chomp.split('').map(&:to_i)
  end

  def prompt_secret_code
    puts "#{@name.red}, enter a 4 digit number for the computer to guess" \
    '(between 1-6'
    gets.chomp.split('').map(&:to_i)
  end
end

# class Computer
class Computer
  include Display
  attr_accessor :name

  def initialize
    @combo = []
    @name = 'Computer'
    @correct_num_position = 0
    @correct_num = 0
    @received_feedback = []
  end

  def generate_code
    code = []
    4.times do
      code << (rand * 6 + 1).floor
    end
    code
  end

  def codemaker_logic(combo)
    comp_guess = 1122.to_s.split('').map!(&:to_i)
  end

  def reset_counter
    @correct_num_position = 0
    @correct_num = 0
  end

  def secret_code
    prompt_secret_code
    gets.chomp.split('').map!(&:to_i)
  end

  def possible_combos
    ([1, 2, 3, 4, 5, 6] * 4).combination(4).to_a.uniq.sort.map!(&:join)
  end

  def received_feedback
    [@correct_num_position, @correct_num]
  end
end

# main
def play_again?(game) # put outside of game class and into the main function
  puts "\nPlay again? Enter 'Y' for Yes or any key to exit:"
  input = gets.chomp.upcase
  game.play if input == 'Y'
  at_exit { puts 'Thank you for playing Mastermind!' }
  exit
end

game = Game.new
game.play
play_again?(game)

# comp = Computer.new
# comp.codemaker_logic(1123)
