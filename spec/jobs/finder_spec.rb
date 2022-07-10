# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FinderJob, type: :job do
  subject(:job) { described_class.perform_now(search_id: search_id) }

  let(:search_id) { '1' }

  it 'performs a search' do
    expect(::Search::CreateQueries).to receive(:run!).with(search_id: search_id)
    job
  end
end
