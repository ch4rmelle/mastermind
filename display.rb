require_relative 'colors'


# prints feedback and instructions
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

  def display_round(rounds)
    puts "\n\n#{'ROUND:'.magenta.bold} #{rounds}"
  end
end