require 'rails_helper'

RSpec.describe Search, type: :model do
  include ActiveJob::TestHelper


  describe 'query pattern processing' do

    describe 'string plus target' do
      subject {Search.create(query: 'durante la <?>')}
      let(:regex) {subject.pattern}
      let(:queries) {subject.queries}

      it { should_not be_nil }

      it 'can generate a valid regex' do
        expect(regex).to be_an_instance_of(Regexp)
        expect(regex).to eq(Regexp.new('durante la (?<target>[[:alpha:]]+)'))
      end

      it 'can generate a valid list of queries' do
        expect(queries).to match_array(['"durante la *"'])
      end
    end

    describe 'category plus target' do
      before do
        c = Category.create(name: 'article')
        Word.create(phrase: 'la', category: c)
        Word.create(phrase: 'el', category: c)
        Word.create(phrase: 'lo', category: c)
      end

      subject {Search.create(query: 'durante <:article:> <?>')}

      let(:regex) {subject.pattern}
      let(:queries) {subject.queries}

      it { should_not be_nil }

      it 'can generate a valid regex' do
        expect(regex).to be_an_instance_of(Regexp)
        expect(regex).to eq(Regexp.new('durante (la|el|lo) ([[:alpha:]]+)'))
      end

      it 'can generate a valid list of queries' do
        expect(queries).to match_array(['"durante la *"', '"durante el *"', '"durante lo *"'])
      end
    end
  end

  describe 'Search result recording' do
    subject {Search.create(query: 'durante la <?>')}
    let(:word) { 'conflicto' }
    let(:context) { 'Durante el conflicto belico en Europa.' }
    let(:page) {
      Page.create(
        link: 'http://wikipedia.com/bla.htm',
        body: 'body bla bla.' + word + 'something else here.'
      )
    }

    it 'can record all the entires on the db' do
      subject.add_result({word: word, context: context, page: page})
    end
  end


  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
