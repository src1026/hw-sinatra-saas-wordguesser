class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  attr_accessor :word, :guesses, :wrong_guesses

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    # Validate input
    raise ArgumentError if letter.nil? || letter.empty? || !letter.match?(/[a-zA-Z]/)
    
    # Convert to lowercase for case insensitive comparison
    letter = letter.downcase
    
    # Check if letter is already guessed
    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      return false
    end
    
    # Check if letter is in the word
    if @word.downcase.include?(letter)
      @guesses += letter
    else
      @wrong_guesses += letter
    end
    
    true
  end

  def word_with_guesses
    result = ''
    @word.downcase.each_char do |char|
      if @guesses.include?(char)
        result += char
      else
        result += '-'
      end
    end
    result
  end

  def check_win_or_lose
    # Check for win: all letters in the word have been guessed
    if @word.downcase.chars.all? { |char| @guesses.include?(char) }
      return :win
    end
    
    # Check for lose: 7 or more wrong guesses
    if @wrong_guesses.length >= 7
      return :lose
    end
    
    # Otherwise, continue playing
    :play
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end
end
