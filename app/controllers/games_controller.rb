require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = []
    9.times do
      @grid.push(('A'..'Z').to_a.sample)
    end
  end

  def parser(word)
    serialized_result = URI.open("https://wagon-dictionary.herokuapp.com/#{@word}").read
    JSON.parse(serialized_result)
  end

  def dict_checker(json_hash)
    json_hash["found"]
  end

  def grid_checker(word, grid)
    not_valid = word.upcase.chars.any? { |letter| grid.include?(letter) == false }
    not_valid = word.upcase.chars.any? { |letter| grid.count(letter) < word.upcase.count(letter) } if not_valid == false
    not_valid
  end

  def score
    @word = params[:word]
    @grid = params[:grid]
    if !dict_checker(parser(@word))
      @result = "Sorry but #{@word.upcase} does not seem to be an English word"
    elsif grid_checker(@word, @grid)
      @result = "#{@word.upcase} is not in the grid"
    else
      @result = "Congrats! #{@word.upcase} is a valid English word!"
    end
  end
end
