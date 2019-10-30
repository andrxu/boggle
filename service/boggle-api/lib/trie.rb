# frozen_string_literal: true

# This implements the Trie class
class Trie
  def initialize
    @root = TrieNode.new('*')
  end

  # Add a word into the trie
  def add_word(word)
    chars = word.chars
    current = @root

    chars.each do |c|
      current = add_character(c, current)
      current.word_count += 1
    end
    current.is_word = true
  end

  # Find a word in the trie
  def find_word(word)
    chars = word.chars
    current = @root

    word_found =
      chars.all? { |c| current = current.children.find { |n| n.value == c } }
    yield word_found, current if block_given?

    current
  end

  # Find if a prefix is valid (there are words with this prefix)
  def find_prefix(prefix)
    node = find_word prefix.downcase
    if node.nil?
      [false, false, 0]
    else
      count = node.word_count
      count -= 1 if node.is_word
      [true, node.is_word, count]
    end
  end

  # Fina a word in the trie
  def include?(word)
    find_word(word) { |found, current| return found && current.is_word }
  end

  def add_character(character, trie_node)
    trie_node.children.find { |n| n.value == character } ||
      add_node(character, trie_node)
  end

  def add_node(character, trie_node)
    TrieNode.new(character).tap { |new_node| trie_node.children << new_node }
  end
end
