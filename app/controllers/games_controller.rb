class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    # on crée un tableau avec les lettres de l'alphabet
    alphabet = ('A'..'Z').to_a
    # on génère un autre tableau avec 10 lettres au hazard de l'alphabet
    @letters = []
    10.times do
      @letters << alphabet.sample
    end
  end

  def score
    @attempt = params[:word]
    # on récupère la liste de lettres proposées depuis l'envoi
    # car on ne peut pas récupérer directement @letters de l'action new
    @letters = params[:letters].split
    word = JSON.parse(URI.parse("https://dictionary.lewagon.com/#{@attempt.downcase}").read)
    if word['found']
       @result = "Congratulation! #{@attempt} is an English word!"
    else
      @result = "Sorry but #{@attempt} is not an English word..."
    end
    # On teste que les lettres sont bien présentes et dans le nombre correspondant
    testing_array = @attempt.upcase.chars.sort.tally.map { |k, v| @letters.include?(k) && v <= @letters.sort.tally[k] }
    @result = "Sorry but #{@attempt} can't be built out of #{@letters.join(",")}..." if testing_array.include?(false)
  end
end
