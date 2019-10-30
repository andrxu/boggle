# frozen_string_literal: true

module DomainData
  # This class hold the dictionary
  class Dictionary
    count = 0

    # TODO: words longer than the board size can be pruned
    Trie = Trie.new
    File.readlines('./data/20k.txt').each do |line|
      Trie.add_word(line.strip)
      count += 1
    end
    puts count.to_s + ' words loaded.'
  end
end
