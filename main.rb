
class Hangman
    WORDS = File.open('5desk.txt','r').readlines
    @@guesses = 1
    def initialize
        player_guesses(word_generator(WORDS))
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
        word_display = "#"*word.length
        guessed_letters = []
        p word_display
        puts "\n"
        while @@guesses <= 6 do 
            puts "Enter your guess here: "
            input = gets.chomp
            until input.length == 1 && ('a'..'z').include?(input.downcase) && guessed_letters.include?(input.downcase) == false do
                puts "Invalid input, please enter another guess..."
                input = gets.chomp
            end
            if word.downcase.include?(input.downcase)
                puts "Good one!"
                word.split('').each_with_index do |letter,index|
                    if input.downcase == letter.downcase
                        word_display[index] = letter
                    end
                end
                puts "\n","Secret word: " + word_display
                guessed_letters.push(input.downcase)
                puts "\n Guessed letters so far: "
                puts guessed_letters.join( " | ")
            else
                @@guesses += 1
                guessed_letters.push(input.downcase)
                puts "Oops! that's incorrect, try again..."
                puts "\n","Secret word: " + word_display
                puts "\n Guessed letters so far: "
                puts guessed_letters.join( " | ")
            end
            if word_display == word
                @@guesses = 7
                puts "\n Congratulations, you won the game and saved our fellow hangman!"
            else
                puts "\n Chances left: #{7 - @@guesses}" 
            end
        end
        if word_display != word
            puts "Too bad, you couldn't save the hangman!" 
        end 

    end

end


Hangman.new 

