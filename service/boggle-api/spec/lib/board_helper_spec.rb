# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/board_helper.rb'

RSpec.describe BoardHelper do
  subject { described_class.new }

  describe '#find_word_on_board' do
    context 'happy path' do
      let(:board_str) { 'ABCDEFGHIJKLMNOP' }

      it 'returns true' do
        expect(BoardHelper.word_on_board?(board_str, 'ABCDHLPONMIEFGKJ')).to eq true
      end
    end
  end

  describe '#find_word_on_board' do
    context 'happy path' do
      let(:board_str) { 'TREEIBEOEEZCTXON' }

      it 'returns true' do
        expect(BoardHelper.word_on_board?(board_str, 'TREE')).to eq true
      end
    end
  end

  describe '#find_word_on_board' do
    context 'happy path' do
      let(:board_str) { 'TREEIBEOEEZCTXON' }

      it 'returns true' do
        expect(BoardHelper.word_on_board?(board_str, 'EERT')).to eq true
      end
    end
  end

  describe '#find_word_on_board' do
    context 'happy path with lower case word' do
      let(:board_str) { 'TREEIBEOEEZCTXON' }

      it 'returns true' do
        expect(BoardHelper.word_on_board?(board_str, 'eert')).to eq true
      end
    end
  end

  describe '#find_word_on_board' do
    context 'happy path' do
      let(:board_str) { 'TREEIBEOEEZCTXON' }

      it 'returns true' do
        expect(BoardHelper.word_on_board?(board_str, 'TEEE')).to eq true
      end
    end
  end

  describe '#find_word_on_board' do
    context 'non existing word' do
      let(:board_str) { 'ABCDEFGHIJKLMNOP' }

      it 'returns false since the word is not found on the board' do
        expect(BoardHelper.word_on_board?(board_str, 'ABCDHLPONMIEFGKZ')).to eq false
      end
    end
  end
end
