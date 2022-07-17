# frozen_string_literal: true

require 'rails_helper'

describe SearchAddResultsJob, type: :job do
  subject(:job) { described_class.perform_now(search_id: search_id, page_id: page_id) }

  let(:search_id) { 'search-id-1' }
  let(:page_id) { 'page-id-1' }

  it 'performs a search' do
    expect(::Search::AddResults).to receive(:run!).with(search_id: search_id, page_id: page_id)
    job
  end
end
