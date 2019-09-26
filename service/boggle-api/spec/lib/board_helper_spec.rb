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
    context 'non existing word' do
      let(:board_str) { 'ABCDEFGHIJKLMNOP' }

      it 'returns false since the word is not found on the board' do
        expect(BoardHelper.word_on_board?(board_str, 'ABCDHLPONMIEFGKZ')).to eq false
      end
    end
  end
end
