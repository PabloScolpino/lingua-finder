# frozen_string_literal: true

require 'rails_helper'

describe Search::CreateQueries do
  ActiveJob::Base.queue_adapter = :test

  subject(:service) { described_class.run!(search_id: search_id) }

  let(:search) { create(:search) }
  let(:search_id) { search.id.to_s }

  context 'when the search exists' do
    before { allow(SearchQuery::Create).to receive(:run!).and_return(create(:search_query, :performed)) }

    it 'calls SearchQuery::Create' do
      expect(SearchQuery::Create).to receive(:run!).once
      service
    end

    it { expect { service }.to have_enqueued_job(SearchAddResultsJob).twice }
  end

  context 'when the search does not exist' do
    let(:search_id) { 'unexistent' }

    it { expect { service }.to raise_error(ActiveRecord::RecordNotFound) }
  end
end
