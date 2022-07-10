# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Parser do
  describe '#strings' do
    subject(:strings) { described_class.parse(query).strings }

    context 'string plus target' do
      let(:query) { 'durante la <?>' }
      let(:expected_queries) { ['allintext:"durante la"'] }

      it { is_expected.to match_array(expected_queries) }
    end

    context 'with category' do
      before { create(:article_with_words, words: %w[la el lo]) }
      let(:query) { 'durante <:article:> <?>' }

      let(:expected_queries) {
        [
          'allintext:"durante la"',
          'allintext:"durante el"',
          'allintext:"durante lo"'
        ]
      }

      it { is_expected.to match_array(expected_queries) }
    end

    context 'with multiple categories' do
      before do
        create(:article_with_words, words: %w[la el])
        create(:name_with_words, words: %w[casa auto])
      end

      let(:query) { '<:article:> <:name:> <?>' }
      let(:expected_queries) {
        [
          'allintext:"la casa"',
          'allintext:"la auto"',
          'allintext:"el casa"',
          'allintext:"el auto"'
        ]
      }

      it { is_expected.to match_array(expected_queries) }
    end

    context 'with empty category' do
      before { create(:article_with_words, words: []) }

      let(:query) { 'durante <:article:> <?>' }
      let(:expected_queries) { [] }

      it { is_expected.to match_array(expected_queries) }
    end

    context 'with category and filter' do
      before { create(:article_with_words) }

      let(:query) { 'durante <:article:/.*a.*/> <?>' }
      let(:expected_queries) { ['allintext:"durante la"'] }

      it { is_expected.to match_array(expected_queries) }
    end
  end
end
