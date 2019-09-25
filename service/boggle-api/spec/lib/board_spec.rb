# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/board.rb'

RSpec.describe Board do
  let(:board_str) { 'UADNOYUTAHERABHF' }
  subject { described_class.new(board_str) }

  describe '#to_s' do
    context 'simple case' do
      let(:board_str) { 'UADNOYUTAHERABHF' }

      it 'returns the correct board string' do
        expect(subject.to_s).to eq board_str
      end
    end
  end

  describe '#find_word_on_board' do
    context 'happy path' do
      let(:board_str) { 'ABCDEFGHIJKLMNOP' }

      it 'returns true' do
        expect(subject.find_word_on_board?('ABCDHLPONMIEFGKJ')).to eq true
      end
    end
  end

  describe '#find_word_on_board' do
    context 'non existing word' do
      let(:board_str) { 'ABCDEFGHIJKLMNOP' }

      it 'returns false since the word is not found on the board' do
        expect(subject.find_word_on_board?('ABCDHLPONMIEFGKZ')).to eq false
      end
    end
  end
end
