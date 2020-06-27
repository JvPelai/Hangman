require 'json'

class Hangman
    attr_accessor :guesses 
    WORDS = File.open('5desk.txt','r').readlines
    def initialize
        puts "Welcome to hangman!, press 1 to start a new game or 2 to load a previous game."
        game_choice = gets.chomp.to_i
        if game_choice == 1
            new_game
        elsif game_choice == 2
            load_game
        else
            new_game
        end
    end

    def new_game
        @guesses = 1
        @guessed_letters = []
        @word = word_generator(WORDS)
        @word_display = "#"*@word.length
        player_guesses(@word)

    end
    
    def load_game
        files = Dir.children("save_data")
        puts "Select the file you wish to load: "
        files.each_with_index do |file,index|
            puts (index.to_i + 1).to_s + ": " + file
        end
        input = gets.chomp.to_i
        file_to_load = "save_data/" + files[input - 1]
        save = File.read(file_to_load)
        data = JSON.parse(save)
        load_data(data)
    end

    def load_data(data)
        @guesses = data["guesses"]
        @guessed_letters = data["guessed_letters"]
        @word = data["word"]
        @word_display = data["word_display"]
        player_guesses(@word)
    end

    def word_generator(words)
        random_word = words[rand(words.length)]
        while random_word.length < 5 || random_word.length > 12 do 
            random_word = words[rand(words.length)]
        end
        p random_word.chomp
        return random_word.chomp
    end

    def player_guesses(word)
        p @word_display
        puts "\n"
        while @guesses <= 6 do 
            puts "Enter your guess here: "
            input = gets.chomp
            until input.length == 1 && ('a'..'z').include?(input.downcase) && @guessed_letters.include?(input.downcase) == false do
                puts "Invalid input, please enter another guess..."
                input = gets.chomp
            end
            if @word.downcase.include?(input.downcase)
                puts "Good one!"
                @word.split('').each_with_index do |letter,index|
                    if input.downcase == letter.downcase
                        @word_display[index] = letter
                    end
                end
                puts "\n","Secret word: " + @word_display
                @guessed_letters.push(input.downcase)
                puts "\n Guessed letters so far: "
                puts @guessed_letters.join( " | ")
            else
                @guesses += 1
                @guessed_letters.push(input.downcase)
                puts "Oops! that's incorrect, try again..."
                puts "\n","Secret word: " + @word_display
                puts "\n Guessed letters so far: "
                puts @guessed_letters.join( " | ")
            end
            if @word_display == word
                @guesses = 7
                puts "\n Congratulations, you won the game and saved our fellow hangman!"
            else
                puts "\n Chances left: #{7 - @guesses}"
                puts "\n Do you want to save the game? y/n"
                save_answer = gets.chomp.downcase
                if save_answer == 'y'
                    save_game
                end 
            end
        end
        if @word_display != word
            puts "Too bad, you couldn't save the hangman!" 
        end 

    end

    def get_game_data(save_destiny)
        game_data = JSON.dump({
            :guesses => @guesses,
            :word => @word,
            :guessed_letters => @guessed_letters,
            :word_display => @word_display
        })
        save_destiny.puts game_data
    end


    def save_game 
        puts "write the name you would like to give your save file"
        save_file_name = gets.chomp
        save_file_path = "save_data/" + save_file_name + ".json" 
        if File.file?(save_file_path)
            puts "This save file already exists, do you want to overwrite it? y/n"
            overwrite = gets.chomp
            if overwrite.downcase == 'n'
                puts 'write a new name for your file:'
                save_file_name = gets.chomp
                save_file_path = "save_data/" + save_file_name + ".json"
            end
        end
        save_destiny = File.open(save_file_path,'w') 
        get_game_data(save_destiny)
    end



end


Hangman.new 

