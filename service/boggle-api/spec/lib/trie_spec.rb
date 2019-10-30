# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/trie.rb'

RSpec.describe Trie do
  subject { described_class.new }

  describe '#add_word' do
    context 'happy path' do
      trie = Trie.new

      trie.add_word('cat')
      trie.add_word('cats')
      trie.add_word('cup')

      trie.add_word('dog')
      trie.add_word('sheep')

      it 'returns true' do
        expect(trie.include?('cat')).to eq true
        expect(trie.include?('cats')).to eq true
        expect(trie.include?('cap')).to eq false
        expect(trie.include?('sheep')).to eq true

        expect(trie.find_word('c').word_count).to eq 3
        expect(trie.find_word('ca').word_count).to eq 2
        expect(trie.find_word('cats').word_count).to eq 1
      end
    end
  end

  describe '#find_prefix' do
    context 'happy path' do
      trie = Trie.new

      trie.add_word('cat')
      trie.add_word('cats')
      trie.add_word('cup')

      it 'returns the state of a prefix' do
        valid, word, count = trie.find_prefix('c')
        expect(valid).to eq true
        expect(word).to eq false
        expect(count).to eq 3

        valid, word, count = trie.find_prefix('ca')
        expect(valid).to eq true
        expect(word).to eq false
        expect(count).to eq 2

        valid, word, count = trie.find_prefix('cat')
        expect(valid).to eq true
        expect(word).to eq true
        expect(count).to eq 1

        valid, word, count = trie.find_prefix('cats')
        expect(valid).to eq true
        expect(word).to eq true
        expect(count).to eq 0
      end
    end
  end

  describe '#add_word with the real dictionary' do
    context 'happy path' do
      my_trie = DomainData::Dictionary::Trie

      it 'returns true' do
        expect(my_trie.include?('cat')).to eq true
        expect(my_trie.include?('sheep')).to eq true
        expect(my_trie.include?('amazon')).to eq true
        expect(my_trie.include?('lifecycle')).to eq true
        expect(my_trie.include?('misspelled word')).to eq false
      end
    end
  end
end