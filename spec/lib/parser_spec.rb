# frozen_string_literal: true

require 'rails_helper'

describe ::Parser do
  subject(:parser) { described_class.parse(query) }

  describe '#strings' do
    subject(:strings) { parser.strings }

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

  describe '#pattern' do
    subject(:strings) { parser.pattern }

    let(:expected_regex) { Regexp.new(expected_regex_pattern) }

    context 'string plus target' do
      let(:query) { 'durante la <?>' }
      let(:expected_regex_pattern) { 'durante[[:space:]]+la[[:space:]]+(?<target>[[:alpha:]]+)' }

      it 'can generate a regex' do
        expect(subject).to be_an_instance_of(Regexp)
        expect(subject).to eq(expected_regex)
      end
    end

    context 'with category' do
      before { create(:article_with_words, words: %w[la el lo]) }

      let(:query) { 'durante <:article:> <?>' }
      let(:expected_regex_pattern) do
        'durante[[:space:]]+(la|el|lo)[[:space:]]+(?<target>[[:alpha:]]+)'
      end

      it 'generates a regex' do
        expect(subject).to be_an_instance_of(Regexp)
        expect(subject).to eq(expected_regex)
      end
    end

    context 'with multiple categories' do
      before do
        create(:article_with_words, words: %w[la el])
        create(:name_with_words, words: %w[casa auto])
      end

      let(:query) { '<:article:> <:name:> <?>' }

      let(:expected_regex_pattern) do
        '(la|el)[[:space:]]+(casa|auto)[[:space:]]+(?<target>[[:alpha:]]+)'
      end

      it 'generates a regex' do
        expect(subject).to be_an_instance_of(Regexp)
        expect(subject).to eq(expected_regex)
      end
    end

    context 'with empty category' do
      before { create(:article_with_words, words: []) }

      let(:query) { '<:article:> <?>' }
      let(:expected_regex_pattern) { '(?<target>[[:alpha:]]+)' }

      it 'generates a target only pattern' do
        expect(subject).to be_an_instance_of(Regexp)
        expect(subject).to eq(expected_regex)
      end
    end

    context 'with category and filter' do
      before { create(:article_with_words) }

      let(:query) { 'durante <:article:/.*a.*/> <?>' }
      let(:expected_regex_pattern) { 'durante[[:space:]]+(la)[[:space:]]+(?<target>[[:alpha:]]+)' }

      it 'generates a  pattern' do
        expect(subject).to be_an_instance_of(Regexp)
        expect(subject).to eq(expected_regex)
      end
    end

    context 'with category in target' do
      before { create(:article_with_words, words: %w[la el lo]) }

      let(:query) { 'durante <?:article:>' }
      let(:expected_regex_pattern) { 'durante[[:space:]]+(?<target>(la|el|lo))([[:space:]]|[[:punct:]])+' }

      it 'generates a regex' do
        expect(subject).to be_an_instance_of(Regexp)
        expect(subject).to eq(expected_regex)
      end
    end

    context 'with regex in target' do
      let(:query) { 'durante <?/.*a/>' }
      let(:expected_regex_pattern) { 'durante[[:space:]]+(?<target>.*a)([[:space:]]|[[:punct:]])+' }

      it 'generates a regex' do
        expect(subject).to be_an_instance_of(Regexp)
        expect(subject).to eq(expected_regex)
      end
    end

    context 'with regex in target 2' do
      let(:query) { 'durante <?/.*ncho/>' }
      let(:expected_regex_pattern) { 'durante[[:space:]]+(?<target>.*ncho)([[:space:]]|[[:punct:]])+' }

      it 'generates a regex' do
        expect(subject).to be_an_instance_of(Regexp)
        expect(subject).to eq(expected_regex)
      end
    end

    context 'with regex in target 3' do
      let(:query) { 'durante <?/.*nga/>' }
      let(:expected_regex_pattern) { 'durante[[:space:]]+(?<target>.*nga)([[:space:]]|[[:punct:]])+' }

      it 'generates a regex' do
        expect(subject).to be_an_instance_of(Regexp)
        expect(subject).to eq(expected_regex)
      end
    end

    context 'with regex in target 4' do
      let(:query) { 'durante <?/\Sa/>' }
      let(:expected_regex_pattern) { 'durante[[:space:]]+(?<target>\Sa)([[:space:]]|[[:punct:]])+' }

      it 'generates a regex' do
        expect(subject).to be_an_instance_of(Regexp)
        expect(subject).to eq(expected_regex)
      end
    end

    context 'with category and regex in target' do
      before { create(:article_with_words, words: %w[la el lo las]) }

      let(:query) { 'durante <?:article:/.*a.*/>' }
      let(:expected_regex_pattern) { 'durante[[:space:]]+(?<target>(la|las))([[:space:]]|[[:punct:]])+' }

      it 'generates a regex' do
        expect(subject).to be_an_instance_of(Regexp)
        expect(subject).to eq(expected_regex)
      end
    end
  end
end
