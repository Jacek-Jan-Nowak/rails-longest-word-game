require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = []
    9.times { @letters << rand(65..90).chr }
    return @letters
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    run_game
  end
end

def run_game
  url = "https://wagon-dictionary.herokuapp.com/#{@word}"
  word_info = URI.open(url).read
  word = JSON.parse(word_info)

  result = word["found"]

  @word = @word.upcase

  if word_included_in_grid?
    if result
      message = "well done!"
    
    elsif result == "spell"
      message = "not an english word"
    else
      message = "invalid word"
    end
  else
    message = "not in the grid"
  end

  @final = { message: message }
end

def word_included_in_grid?
  @word = @word.upcase
  @word.chars.all?  { |letter| @word.count(letter) <= @letters.count(letter) }
  # @word.split('').all? { |letter| @word.count(letter) <= @letters.count(letter) }
end