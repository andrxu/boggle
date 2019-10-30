# frozen_string_literal: true

require_relative './dictionary_accessor.rb'
require 'set'

class BoardHelper
  MIN_WORD_LEN = 2
  PLACE_HOLDER = '*'

  @trie = DomainData::Dictionary::Trie

  BOARD_DIMS = [4 * 4].freeze # Only 4x4 is supported

  # use predefined seeds to generate boards possibly having more words
  CUBES = %w[AAEEGN ABBJOO ACHOPS AFFKPS AOOTTW CIMOTU DEILRX DELRVY
             DISTTY EEGHNW EEINSU EHRTVW EIOSST ELRTTY HIMNQU HLNNRZ].freeze

  # check if a word is on the board first, then check against a dictionary
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
  # TODO: handle exception gracefully
  def self.word_on_board?(board_str, word)
    check_board(board_str)

    if word.nil? || (word.length < MIN_WORD_LEN)
      raise "invalid word length: #{word}"
    end

    word_search = word.upcase
    grid = convert_board_str(board_str)

    found_on_board = false
    (0...grid.length).each do |r|
      (0...grid[0].length).each do |c|
        if grid[r][c] == word_search[0]
          found_on_board = find_word_helper(grid, word_search, r, c, 0)
          break if found_on_board
        end
      end
      break if found_on_board
    end
    found_on_board
  end

  # solve a board - search all valid words on the board
  def self.solve_board(board_str)
    check_board(board_str)

    grid = convert_board_str(board_str)
    result = Set.new

    (0...grid.length).each do |row|
      (0...grid[0].length).each do |col|
        solve_helper(grid, row, col, '', result)
      end
    end

    result.to_a.sort
  end

  def self.word_valid?(word)
    # DictionaryAccessor.word_valid? word
    DictionaryAccessor.word_valid_local? word
  end

  # pretty print the board for debugging
  def self.show(board_str)
    # check_board(board_str)
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

  def self.convert_board_str(board_str)
    to_array(board_str.upcase)
  end

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

  def self.check_board(board_str)
    raise "invalid board string length #{board_str}" unless BOARD_DIMS.include?(board_str.length)
  end

  def self.find_word_helper(grid, word, row, col, index)
    return true if index == word.length

    if grid[row][col] != word[index] || grid[row][col] == PLACE_HOLDER
      return false
    end

    size = grid.length
    found_on_board = false
    grid[row][col] = PLACE_HOLDER
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

  def self.solve_helper(grid, row, col, prefix, result)
    char = grid[row][col]

    return if grid[row][col] == PLACE_HOLDER

    valid = false
    count = 0
    valid, is_word, count = @trie.find_prefix prefix unless prefix.length <= 1
    if prefix.length <= 1
      valid = true
      count = 1
    end

    # dfs pruning
    return if !valid || count.zero?

    if is_word
      result.add prefix if prefix.length > MIN_WORD_LEN # filter out short words
    end

    grid[row][col] = PLACE_HOLDER
    (row - 1...row + 2).each do |r|
      (col - 1...col + 2).each do |c|
        solve_helper(grid, r, c, prefix + grid[r][c], result) if valid?(grid, r, c)
      end
    end
    grid[row][col] = char
  end

  def self.valid?(grid, row, col)
    rows = grid.length
    cols = grid[0].length
    row >= 0 && col >= 0 && row < rows && col < cols && grid[row][col] != PLACE_HOLDER
  end
end
