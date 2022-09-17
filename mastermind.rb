class String
  def green; "\e[32m#{self}\e[0m" end
  def red;   "\e[31m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
end

class Game
  def initialize
    @correct_num_position = 0
    @correct_num = 0
    @rounds = 0
    @@valid_nums = [1, 2, 3, 4, 5, 6]
    instructions
    user_choice
  end

  def instructions
    puts "Welcome to Mastermind! Ready for a code-breaking challenge?\n" \
    "Test the computer's code-breaking skills or your own." \
    "\n\nYou have 2 options: 1) Be a #{'CODE-MAKER'.red} or 2) Be a " \
   "#{'CODE-BREAKER'.blue}  \n\n#{'CODE-MAKER'.red} - Make up a 4 digit combination" \
   ' and have the computer guess it in 12 turns or less.' \
   "\n\n#{'CODE-BREAKER'.blue} - The computer chooses a 4 digit combination" \
   ' and you try to guess it in 12 turns or less.' \
   "\nPlayer will receive feedback after each turn:\n" \
   "\t#{'●'.green} = Correct number and correct position\n"\
   "\t○ = Correct number but wrong position\n"
  end

  def user_choice
    puts "\nEnter your choice: 1) Be a #{'CODE-MAKER'.red} 2) Be a " \
    "#{'CODE-BREAKER'.blue}  "
    @choice = gets.chomp.to_i
    play(@choice)
  end

  def play(choice)
    case choice
    when 1
      codemaker_play
    when 2
      codebreaker_play
    end
  end

  protected

  def codebreaker_play
    @comp = Computer.new
    combo = @comp.generate_combo

    while (@rounds <= 12)
      p combo # remove after debugging
      
      # if user_combo.include?(@valid_nums)
      loop do
        puts "\nPlease enter a 4 digit combination (1-6)"
        user_combo = gets.chomp.split('').map(&:to_i)
        p combo
        if user_combo == combo
          puts "You cracked the code!"
          return
        end
        
        for i in 0..combo.length - 1
          if user_combo[i].to_i == combo[i]
            @correct_num_position += 1
          elsif combo.include?(user_combo[i])
            @correct_num += 1
          end
      end
          
        @correct_num_position.times do
          print "● ".green
        end
        @correct_num.times do
          print "○ "
        end
      
        @correct_num_position = 0
        @correct_num = 0
        @rounds += 1
      end
      # else
      #   puts "Invalid input! Enter a 4 digit combo between 1-6"
      # end
    end
  end


  




end
# class Player

# class Human

# class Computer
class Computer
  def initialize
    @combo = []
  end

  def generate_combo
    4.times do
      @combo << (rand * 6 + 1).floor
    end
    @combo
  end
end

# module Display
game = Game.new
