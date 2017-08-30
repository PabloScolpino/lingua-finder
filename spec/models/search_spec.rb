require 'rails_helper'

RSpec.shared_examples 'a_regex_generator' do
  subject { create(:search, query: query_string).pattern }

  let(:expected_regex) do
    Regexp.new(regex_string)
  end

  it { is_expected.to be_an_instance_of(Regexp) }
  it { is_expected.to eq(expected_regex) }
end

RSpec.describe Search, type: :model, vcr: {} do
  include ActiveJob::TestHelper

  describe '#queries' do
    context 'invalid query' do
      subject { create(:search, query: 'durante').query }

      it { is_expected_block.to raise_error(ActiveRecord::RecordInvalid) }
    end

    context 'invalid query 2' do
      subject { create(:search, query: '<?>').query }

      it { is_expected_block.to raise_error(ActiveRecord::RecordInvalid) }
    end

    context 'string plus target' do
      subject { create(:search).queries }
      let(:expected_queries) do
        [
          'allintext:"durante la"'
        ]
      end

      it { is_expected.to match_array(expected_queries) }
    end

    context 'with category' do
      before { create(:article_with_words, words: %w(la el lo)) }

      subject { create(:search, query: 'durante <:article:> <?>').queries }

      let(:expected_queries) do
        [
          'allintext:"durante la"',
          'allintext:"durante el"',
          'allintext:"durante lo"'
        ]
      end

      it { is_expected.to match_array(expected_queries) }
    end

    context 'with multiple categories' do
      before do
        create(:article_with_words, words: %w(la el))
        create(:name_with_words, words: %w(casa auto))
      end

      subject { create(:search, query: '<:article:> <:name:> <?>').queries }

      let(:expected_queries) do
        [
          'allintext:"la casa"',
          'allintext:"la auto"',
          'allintext:"el casa"',
          'allintext:"el auto"'
        ]
      end

      it { is_expected.to match_array(expected_queries) }
    end

    context 'with empty category' do
      before do
        create(:article_with_words, words: [])
      end

      subject { create(:search, query: 'durante <:article:> <?>') }

      it 'generates a empty list' do
        expect(subject.queries).to match_array([])
      end
    end

    context 'with category and filter' do
      before do
        create(:article_with_words)
      end

      subject { create(:search, query: 'durante <:article:/.*a.*/> <?>') }

      let(:expected_queries) do
        [
          'allintext:"durante la"'
        ]
      end

      it 'generates a list of queries' do
        expect(subject.queries).to match_array(expected_queries)
      end
    end
  end

  describe '#pattern' do
    context 'string plus target' do
      subject { create(:search).pattern }

      let(:expected_regex) do
        Regexp.new('durante[[:space:]]+la[[:space:]]+(?<target>[[:alpha:]]+)')
      end

      it { is_expected.to be_an_instance_of(Regexp) }
      it { is_expected.to eq(expected_regex) }
    end

    context 'with category 2' do
      let(:query_string) { 'durante <:article:> <?>' }
      let(:regex_string) { 'durante[[:space:]]+(la|el|lo)[[:space:]]+(?<target>[[:alpha:]]+)' }

      before do
        create(:article_with_words, words: %w(la el lo))
      end

      it_behaves_like 'a_regex_generator'
    end

    context 'with multiple categories' do
      before do
        create(:article_with_words, words: %w(la el))
        create(:name_with_words, words: %w(casa auto))
      end

      let(:query_string) { '<:article:> <:name:> <?>' }
      let(:regex_string) { '(la|el)[[:space:]]+(casa|auto)[[:space:]]+(?<target>[[:alpha:]]+)' }

      it_behaves_like 'a_regex_generator'
    end

    context 'with empty category' do
      before do
        create(:article_with_words, words: [])
      end

      let(:query_string) { '<:article:> <?>' }
      let(:regex_string) { '(?<target>[[:alpha:]]+)' }

      it_behaves_like 'a_regex_generator'
    end

    context 'with category and filter' do
      before do
        create(:article_with_words)
      end

      let(:query_string) { 'durante <:article:/.*a.*/> <?>' }
      let(:regex_string) { 'durante[[:space:]]+(la)[[:space:]]+(?<target>[[:alpha:]]+)' }

      it_behaves_like 'a_regex_generator'
    end

    context 'with category in target' do
      before do
        create(:article_with_words, words: %w(la el lo))
      end

      let(:query_string) { 'durante <?:article:>' }
      let(:regex_string) { 'durante[[:space:]]+(?<target>(la|el|lo))([[:space:]]|[[:punct:]])+' }

      it_behaves_like 'a_regex_generator'
    end

    context 'with regex in target' do
      let(:query_string) { 'durante <?/.*a/>' }
      let(:regex_string) { 'durante[[:space:]]+(?<target>.*a)([[:space:]]|[[:punct:]])+' }

      it_behaves_like 'a_regex_generator'
    end

    context 'with regex in target 2' do
      let(:query_string) { 'durante <?/.*ncho/>' }
      let(:regex_string) { 'durante[[:space:]]+(?<target>.*ncho)([[:space:]]|[[:punct:]])+' }

      it_behaves_like 'a_regex_generator'
    end

    context 'with regex in target 3' do
      let(:query_string) { 'durante <?/.*nga/>' }
      let(:regex_string) { 'durante[[:space:]]+(?<target>.*nga)([[:space:]]|[[:punct:]])+' }

      it_behaves_like 'a_regex_generator'
    end

    context 'with regex in target 4' do
      let(:query_string) { 'durante <?/\Sa/>' }
      let(:regex_string) { 'durante[[:space:]]+(?<target>\Sa)([[:space:]]|[[:punct:]])+' }

      it_behaves_like 'a_regex_generator'
    end

    context 'with category and regex in target' do
      before { create(:article_with_words, words: %w(la el lo las)) }

      let(:query_string) { 'durante <?:article:/.*a.*/>' }
      let(:regex_string) { 'durante[[:space:]]+(?<target>(la|las))([[:space:]]|[[:punct:]])+' }

      it_behaves_like 'a_regex_generator'
    end
  end

  describe '#add_result' do
    subject { create(:search) }

    let(:word) { 'conflicto' }
    let(:context) { 'Durante el conflicto belico en Europa.' }

    let(:page) do
      Page.create(
        link: 'http://wikipedia.com/bla.htm',
        body: 'body bla bla.' + word + 'something else here.'
      )
    end

    before do
      subject.add_result(word: word, context: context, page: page)
    end

    it 'can record all the entires on the db' do
      expect(subject.results).not_to be_empty
    end
  end

  describe '.dispatch_downloads' do
    subject { create(:search) }

    before do
      quietly do
        Search.dispatch_downloads(subject.id)
      end
    end

    it 'queues download jobs' do
      have_enqueued_job(DownloaderJob)
    end
  end

  describe '#scrape_internet' do
    subject { create(:search) }

    before do
      @results = subject.scrape_internet
    end

    it 'gets internet results' do
      expect(@results).not_to be_empty
    end
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
