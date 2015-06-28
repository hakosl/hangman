
def read_one_line (file_name, line_number)
  File.open(file_name) do |file|
    file.each_line.with_index do |line, index|
      return line if index == line_number
    end
  end
end


class Hangman 
  def initialize
  	@word = read_one_line("word_list.txt", rand(61405)).downcase[0..-3]
  	@letters_guessed = []
  	@guesses = 0
  	@max_guesses = 20
  end

  def compare_word_and_guesses
  	feedback = ""
  	@word.split("").each do |letter|
  	  if @letters_guessed.include?(letter)
  	  	feedback += "#{letter} "
  	  else
  	  	feedback += "_ "
  	  end
  	end
  	feedback
  end

  def take_input_give_feedback
  	puts "Make a guess"
  	guess = sanitize_guess(gets.chomp)
  	new_guess(guess)
  	puts "#{compare_word_and_guesses} #{@guesses}/#{@max_guesses} guesses"
  end

  def sanitize_guess(guess)
  	return guess.downcase if guess.length == 1
  	return rand(a..z)
  end

  def new_guess(guess)
  	@letters_guessed << guess
  	@guesses += 1
  end

  def did_i_win?
  	@word.split("").each do |letter|
  	  unless @letters_guessed.include?(letter)
  	  	return false
  	  end
  	end
  	true
  end

  def load_game
  	puts "Which game do you want to load?"
  	name = gets.chomp
  	File.open("saved_games/save#{name}.txt") do |file|
  	  save = file.read.split(", ")
  	  @word = save[0]
  	  @guesses = save[1].to_i
  	  @letters_guessed = save[2..-1]
  	end
  end

  def save_game
  	puts "How do you want to save your game?"
  	name = gets.chomp
  	File.open("saved_games/save#{name}.txt", "w") do |file|
  	  output = "#{@word.chomp}, #{@guesses}, "
  	  @letters_guessed.each do |letter|
  	  	output << "#{letter}, "
  	  end
  	  file.write(output)
  	end
  end

  def input_loop
  	puts "load a game or play a new one?"
  	load_game if gets.chomp == "load"

  	while true
  	  if did_i_win?
  	  	game_won = true
  	  	break
  	  elsif @guesses == @max_guesses
  	  	break
  	  end

  	  puts "save your game or guess again?"
  	  save_game if gets.chomp == "save"

  	  take_input_give_feedback
  	end

  	if game_won
  	  puts "gz, you did it"
  	else
  	  puts "YOU FUCKING SUCK"
  	end
  end
end

Hangman.new.input_loop


#puts line = read_one_line("word_list.txt", rand(61405))

