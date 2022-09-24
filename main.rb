require_relative 'game'
require_relative 'computer'
require_relative 'human'
require_relative 'codebreaker'
require_relative 'codemaker'
require_relative 'display'
require_relative 'colors'

def play_again?
  loop do
    puts "\nPlay again? Enter 'Y' for Yes or any key to exit"
    input = gets.chomp.upcase
    while input == 'Y'
      sleep 1
      system('clear')
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
