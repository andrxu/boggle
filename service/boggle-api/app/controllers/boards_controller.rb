class BoardsController < ApplicationController

  require_relative '../../lib/board_helper.rb'

  # GET /boards/new
  def new
    board_str = ::BoardHelper.generate_board
    json_response(board: board_str)
  end

  # check if the word exists on the board, if yes, check the dictionary further
  # GET /boards/:board?find='word'
  def find_word
    board_str = params[:board]
    word = params[:word]
    result = ::BoardHelper.check_word(board_str, word) unless word.nil?
    result = ::BoardHelper.show(board_str) if word.nil?
    json_response(result)
  end

  # GET /boards/:board/words
  def solve_board
    board_str = params[:board]
    result = ::BoardHelper.solve_board(board_str)
    json_response(result)
  end
end

