require_relative 'computer'
require_relative 'human'
require_relative 'display'
require_relative 'colors'
require_relative 'codebreaker'
require_relative 'codemaker'

# class that starts game play
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
end