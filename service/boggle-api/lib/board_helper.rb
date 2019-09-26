# frozen_string_literal: true
require_relative './dictionary_accessor.rb'

class BoardHelper

  MIN_WORD_LEN = 3

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

    seen = Array.new(rows) { Array.new(cols) { false } }
    index = 0
    found_on_board = false
    (0...rows).each do |r|
      (0...cols).each do |c|
        if grid[r][c] == word_search[index]
          found_on_board = dfs(grid, word_search, r, c, index, seen)
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
    dim = Math.sqrt(board_str.length)
    (0...dim).each do |row|
      (0...dim).each do |col|
        print"#{board_str[row * dim + col]} "
      end
      puts
    end
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

  def self.dfs(grid, word, r, c, index, seen)
    if (r < 0) || (c < 0) || (r >= grid.length) || (c >= grid[0].length) ||
       seen[r][c] || (grid[r][c] != word[index])
      return false
    end

    return true if index + 1 == word.length

    seen[r][c] = true
    if  dfs(grid, word, r - 1, c,     index + 1, seen) ||
        dfs(grid, word, r + 1, c,     index + 1, seen) ||
        dfs(grid, word,     r, c - 1, index + 1, seen) ||
        dfs(grid, word,     r, c + 1, index + 1, seen) ||
        dfs(grid, word, r - 1, c - 1, index + 1, seen) ||
        dfs(grid, word, r - 1, c + 1, index + 1, seen) ||
        dfs(grid, word, r + 1, c - 1, index + 1, seen) ||
        dfs(grid, word, r + 1, c + 1, index + 1, seen)
      return true
    end

    seen[r][c] = false
  end
end

