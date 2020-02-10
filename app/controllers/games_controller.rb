require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('a'..'z').to_a.sample.upcase }
  end

  def score
    @word = params[:score]
    @word_array = params[:score].split('')
    @random = params[:letter]
    @random_array = params[:letter].split(" ")
    in_grid
  end

  def in_grid
    letter_hash = Hash.new(0)
    word_hash = Hash.new(0)
    @random_array.each { |letter| letter_hash[letter] += 1 }
    @word_array.each { |letter| word_hash[letter.upcase] += 1 }
    word_hash.each_key do |key|
      if letter_hash[key].nil? || word_hash[key] > letter_hash[key]
        @score = "Sorry but #{@word.upcase} is not included in #{@random}"
      else
        find_word
      end
    end
  end

  def find_word
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    a = open(url).read
    exist = JSON.parse(a)
    if exist['found']
      @score = "Congratulations! #{@word.upcase} is a valid English word"
    else
      @score = "Sorry, but #{@word.upcase} does not seem to be an English word..."
    end
  end
end
