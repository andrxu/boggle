class BoardsController < ApplicationController

  require_relative '../../lib/board_helper.rb'

  # GET /boards/new
  def new
    board_str = ::BoardHelper.generate_board
    json_response(board: board_str)
  end

  # check if the word exists on the board, if yes, it would check the diction further
  # GET /boards/:board?find='word'
  def find_word
    board_str = params[:board]
    word = params[:word]
    result = ::BoardHelper.check_word(board_str, word)
    json_response(result)
  end
end

