require_relative 'display'
# human class to store attributes and methods
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