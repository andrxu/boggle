# frozen_string_literal: true

require_relative './dictionary_accessor.rb'

class BoardHelper

  MIN_WORD_LEN = 2

  BOARD_DIMS = [4 * 4].freeze # Only 4x4 is supported

  # use predefined seeds to generate boards possibly having more words
  CUBES = %w[AAEEGN ABBJOO ACHOPS AFFKPS AOOTTW CIMOTU DEILRX DELRVY
             DISTTY EEGHNW EEINSU EHRTVW EIOSST ELRTTY HIMNQU HLNNRZ].freeze

  def self.check_word(board_str, word)
    found_on_board = word_on_board?(board_str, word)
    word_valid = word_valid?(word) if found_on_board
    {
      board: board_str,
      word: word,
      found_on_board: found_on_board,
      word_valid: word_valid
    }
  rescue StandardError => e
    {
      error: e
    }
  end

  # check if the word exits on the board
  def self.word_on_board?(board_str, word)
    raise "invalid board string length #{board_str}" unless BOARD_DIMS.include?(board_str.length)

    if word.nil? || (word.length < MIN_WORD_LEN)
      raise "invalid word length: #{word}"
    end

    word_search = word.upcase
    grid = to_array(board_str.upcase)
    rows = grid.length
    cols = grid[0].length

    index = 0
    found_on_board = false
    (0...rows).each do |r|
      (0...cols).each do |c|
        if grid[r][c] == word_search[index]
          found_on_board = find_word_helper(grid, word_search, r, c, index)
          break if found_on_board
        end
      end
      break if found_on_board
    end
    found_on_board
  end

  def self.word_valid?(word)
    DictionaryAccessor.word_valid? word
  end

  # pretty print the board for debugging
  def self.show(board_str)
    result = ''
    dim = Math.sqrt(board_str.length)
    (0...dim).each do |row|
      (0...dim).each do |col|
        result += "#{board_str[row * dim + col]} "
      end
      result += "\n"
    end
    result
  end

  # generate a new board
  def self.generate_board
    cubes = CUBES.dup

    # shuffle cubes
    (0...cubes.length).each do |i|
      r = (rand * cubes.length).to_i
      cubes[i], cubes[r] = cubes[r], cubes[i]
    end

    # generate a board by picking a face from each cube randomly
    board_str = ''
    cubes.each do |cube|
      board_str += choose_random_face(cube)
    end
    board_str
  end

  private

  def self.to_array(board_str)
    dim = Math.sqrt(board_str.length)
    board_array = Array.new(dim) { Array.new(dim) { '' } }

    index = 0
    (0...dim).each do |row|
      (0...dim).each do |col|
        board_array[row][col] = board_str[index]
        index += 1
      end
    end
    board_array
  end

  def self.choose_random_face(cube)
    cube[(rand * cube.length).to_i]
  end

  def self.find_word_helper(grid, word, row, col, index)
    place_holder = '*'
    return true if index == word.length

    if grid[row][col] != word[index] || grid[row][col] == place_holder
      return false
    end

    size = grid.length
    found_on_board = false
    grid[row][col] = place_holder
    (row - 1...row + 2).each do |r|
      (col - 1...col + 2).each do |c|
        next unless r >= 0 && c >= 0 && r < size && c < size
        next unless find_word_helper(grid, word, r, c, index + 1)

        grid[row][col] = word[index]
        found_on_board = true
        break
      end
      break if found_on_board
    end

    grid[row][col] = word[index]
    found_on_board
  end
end

