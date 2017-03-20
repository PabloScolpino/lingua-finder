require 'rails_helper'

RSpec.describe Search, type: :model, vcr: {} do
  include ActiveJob::TestHelper

  describe '#queries' do

    context 'string plus target' do
      subject { create(:search) }
      let(:expected_queries) do
        [
          'allintext:"durante la"'
        ]
      end

      it 'can generate a list of queries' do
        expect(subject.queries).to match_array(expected_queries)
      end
    end

    context 'with category' do
      before do
        create(:article_with_words, words: ['la','el','lo'])
      end

      subject { create(:search, query: 'durante <:article:> <?>') }

      let(:expected_queries) do
        [
          'allintext:"durante la"',
          'allintext:"durante el"',
          'allintext:"durante lo"'
        ]
      end

      it 'generates a list of queries' do
        expect(subject.queries).to match_array(expected_queries)
      end
    end

    context 'with multiple categories' do
      before do
        create(:article_with_words, words: ['la','el'])
        create(:name_with_words, words: ['casa','auto'])
      end

      subject { create(:search, query: '<:article:> <:name:> <?>') }

      let(:expected_queries) do
        [
          'allintext:"la casa"',
          'allintext:"la auto"',
          'allintext:"el casa"',
          'allintext:"el auto"',
        ]
      end

      it 'generates a list of queries' do
        expect(subject.queries).to match_array(expected_queries)
      end
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
  end

  describe '#pattern' do

    context 'string plus target' do
      subject { create(:search) }

      let(:expected_regex) do
        Regexp.new('durante[[:space:]]+la[[:space:]]+(?<target>[[:alpha:]]+)')
      end

      it 'can generate a regex' do
        expect(subject.pattern).to be_an_instance_of(Regexp)
        expect(subject.pattern).to eq(expected_regex)
      end
    end

    context 'with category' do
      before do
        create(:article_with_words, words: ['la','el','lo'])
      end

      subject { create(:search, query: 'durante <:article:> <?>') }

      let(:expected_regex) do
        Regexp.new('durante[[:space:]]+(la|el|lo)[[:space:]]+(?<target>[[:alpha:]]+)')
      end

      it 'generates a regex' do
        expect(subject.pattern).to be_an_instance_of(Regexp)
        expect(subject.pattern).to eq(expected_regex)
      end
    end

    context 'with multiple categories' do
      before do
        create(:article_with_words, words: ['la','el'])
        create(:name_with_words, words: ['casa','auto'])
      end

      subject { create(:search, query: '<:article:> <:name:> <?>') }

      let(:expected_regex) do
        Regexp.new('(la|el)[[:space:]]+(casa|auto)[[:space:]]+(?<target>[[:alpha:]]+)')
      end

      it 'generates a regex' do
        expect(subject.pattern).to be_an_instance_of(Regexp)
        expect(subject.pattern).to eq(expected_regex)
      end
    end

    context 'with empty category' do
      before do
        create(:article_with_words, words: [])
      end

      subject { create(:search, query: '<:article:> <?>') }

      let(:expected_regex) do
        Regexp.new('(?<target>[[:alpha:]]+)')
      end

      it 'generates a target only pattern' do
        expect(subject.pattern).to be_an_instance_of(Regexp)
        expect(subject.pattern).to eq(expected_regex)
      end
    end
  end

  describe '#add_result' do
    subject { create(:search) }

    let(:word) { 'conflicto' }
    let(:context) { 'Durante el conflicto belico en Europa.' }

    let(:page) {
      Page.create(
        link: 'http://wikipedia.com/bla.htm',
        body: 'body bla bla.' + word + 'something else here.'
      )
    }

    before do
      subject.add_result({word: word, context: context, page: page})
    end

    it 'can record all the entires on the db' do
      expect(subject.results).not_to be_empty
    end
  end

  describe '.dispatch_downloads' do
    subject { create(:search) }

    before do
      quietly do
        Search.dispatch_downloads (subject.id)
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
