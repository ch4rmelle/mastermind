require_relative 'display'
require_relative 'colors'
require_relative 'game'

# codemaker gameplay
class CodeMaker 
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
      display_round(@rounds)
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

  def reset_feedback_counter
    @correct_num_position = 0
    @correct_num = 0
  end

  def valid_input?(input)
    input.all? { |x| x.between?(1, 6) } && input.length == 4
  end
end