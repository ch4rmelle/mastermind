require_relative 'display'
require_relative 'colors'
require_relative 'game'

class CodeBreaker 
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
      display_round(@rounds)
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

  def result_message(result)
    if result
      puts "\nAmazing! You solved the secret code."
    else
      puts "\nYou lost :( The Secret Code was #{@secret_code.join(' ').green}"
    end
  end

  def reset_feedback_counter
    @correct_num_position = 0
    @correct_num = 0
  end

  def valid_input?(input)
    input.all? { |x| x.between?(1, 6) } && input.length == 4
  end
end