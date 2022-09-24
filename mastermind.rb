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
    puts 'Clues: '
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
    @codebreaker = CodeBreaker.new
    @codemaker = CodeMaker.new
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
    clear_console
    case choice
    when 1
      @codemaker.play
    when 2
      @codebreaker.play
    end
  end

  def reset_feedback_counter
    @correct_num_position = 0
    @correct_num = 0
  end

  def display_round
    puts "\n\n#{'ROUND:'.magenta.bold} #{@rounds}"
  end

  def valid_input?(input)
    input.all? { |x| x.between?(1, 6) } && input.length == 4
  end
end

def result_message(result)
  if result
    puts "\nAmazing! You solved the secret code."
  else
    puts "\nYou lost :( The Secret Code was #{@secret_code.join(' ').green}"
  end
end

class CodeBreaker < Game
  include Display

  def initialize
    @human = Human.new
    @comp = Computer.new
    @win = false
    @correct_num_position = 0
    @correct_num = 0
    @rounds = 1
  end

  def play
    @human.player_name
    @secret_code = @comp.generate_code
    play_rounds
    result_message(@win)
  end

  def play_rounds
    while @rounds <= 12
      display_round
      user_guess = @human.prompt_user_guess
      if valid_input?(user_guess)
        return if win?(user_guess, @secret_code)

        guess_comp_code(user_guess, @secret_code)
      else
        puts "\n Invalid input! Try again."
      end
    end
  end

  protected

  def guess_comp_code(user_guess, secret_code)
    check_guess(user_guess, secret_code)
    display_feedback(@correct_num_position, @correct_num)
    reset_feedback_counter
    @rounds += 1
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

  def win?(user_guess, code)
    @win = user_guess == code
  end
end

class CodeMaker < Game
  include Display

  def initialize
    @human = Human.new
    @comp = Computer.new
    @correct_num_position = 0
    @correct_num = 0
    @possible_combos = ([1, 2, 3, 4, 5, 6] * 4).combination(4).to_a.uniq.sort
    @comp_feedback = []
    @rounds = 1
    @eliminated_combos = []
  end

  def play
    @human.player_name
    loop do
      @secret_code = @human.prompt_secret_code
      break if valid_input?(@secret_code)

      puts 'Invalid input! Try again.'
    end
    @comp_guess = [1, 1, 2, 2]
    guess_secret_code
    puts "\nThe computer guessed your secret code! Secret code is #{@secret_code.join(' ').blue}"
  end

  protected

  def guess_secret_code
    while @comp_guess != @secret_code
      display_round
      display_computer_guess
      comp_feedback
      compare_feedbacks
      remove_incorrect_combos
      reassign_comp_guess
      @rounds += 1
      sleep 1.0
    end
  end

  def comp_feedback
    @comp_guess.each_index do |i|
      if @comp_guess[i] == @secret_code[i]
        @correct_num_position += 1
      elsif @comp_guess.include?(@secret_code[i])
        @correct_num += 1
      end
    end
    @comp_feedback = [@correct_num_position, @correct_num]
    display_feedback(@correct_num_position, @correct_num)
    reset_feedback_counter
  end

  def compare_feedbacks
    @possible_combos.each do |combo|
      combo.each_index do |i|
        if combo[i] == @comp_guess[i]
          @correct_num_position += 1
        elsif @comp_guess.include?(combo[i])
          @correct_num += 1
        end
      end
      combo_feedback = [@correct_num_position, @correct_num]
      @eliminated_combos << combo if @comp_feedback != combo_feedback
      reset_feedback_counter
    end
  end

  def remove_incorrect_combos
    @possible_combos -= @eliminated_combos
  end

  def reassign_comp_guess
    @comp_guess = @possible_combos.sample
  end

  def display_computer_guess
    puts "#{"Computer's Guess:".blue} #{@comp_guess.join(' ')}"
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
    puts "\n#{@name.red}, enter a 4 digit number for the computer to guess" \
    ' (between 1-6)'
    gets.chomp.split('').map!(&:to_i)
  end
end

class Computer
  include Display
  attr_accessor :name

  def initialize
    @name = 'Computer'
  end

  def generate_code
    code = []
    4.times do
      code << (rand * 6 + 1).floor
    end
    code
  end
end

# main
def play_again?
  loop do
    puts "\nPlay again? Enter 'Y' for Yes or any key to exit"
    input = gets.chomp.upcase
    while input == 'Y'
      game = Game.new
      game.play
      break
    end
    break if input != 'Y'
  end
end

def exit_game
  at_exit { puts 'Thank you for playing Mastermind!'}
  exit
end

game = Game.new
game.play
play_again?
exit_game
