require 'rails_helper'
describe 'FinderJob' do
  let(:search) {Search.new(query: 'durante el')}
  let(:searcher) {FinderJob.new}

  it 'can search and parse a result' do
    searcher.perform(search)
  end
end
