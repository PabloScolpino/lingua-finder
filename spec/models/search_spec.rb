require 'rails_helper'

RSpec.describe Search, type: :model, vcr: {} do
  include ActiveJob::TestHelper

  context 'query pattern processing' do

    context 'string plus target' do
      subject { create(:search) }

      let(:regex) {subject.pattern}
      let(:queries) {subject.queries}

      it { should_not be_nil }

      it 'can generate a valid regex' do
        expect(regex).to be_an_instance_of(Regexp)
        expect(regex).to eq(Regexp.new('durante la (?<target>[[:alpha:]]+)'))
      end

      it 'can generate a valid list of queries' do
        expect(queries).to match_array(['allintext:"durante la"'])
      end
    end

    context 'category plus target' do
      before do
        c = Category.create(name: 'article')
        Word.create(phrase: 'la', category: c)
        Word.create(phrase: 'el', category: c)
        Word.create(phrase: 'lo', category: c)
      end

      subject { create(:search, query: 'durante <:article:> <?>') }

      let(:regex) {subject.pattern}
      let(:queries) {subject.queries}

      it { should_not be_nil }

      it 'can generate a valid regex' do
        pending #TODO
        expect(regex).to be_an_instance_of(Regexp)
        expect(regex).to eq(Regexp.new('durante (la|el|lo) ([[:alpha:]]+)'))
      end

      it 'can generate a valid list of queries' do
        pending #TODO
        expect(queries).to match_array(['allintext:"durante la"', 'allintext:"durante el"', 'allintext:"durante lo"'])
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
