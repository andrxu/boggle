# frozen_string_literal: true

#  This defines the Trie node
class TrieNode
  attr_reader    :value, :children
  attr_accessor  :word_count # total words exists for this prefix
  attr_accessor  :is_word # "is word" flag

  def initialize(value)
    @value = value
    @is_word = false
    @word_count = 0
    @children = []
  end
end
