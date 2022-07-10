# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search::CreateQueries do
  ActiveJob::Base.queue_adapter = :test

  subject(:service) { described_class.run!(search_id: search_id) }

  let(:search) { create(:search) }
  let(:search_id) { search.id.to_s }

  context 'when the search exists' do
    before do
      # allow(Parser).to receive(:parse).with(search.query).and_return(double(strings: []))

      allow(SearchQuery::Create).to receive(:run!) do
        create(:search_query, :performed)
      end
    end

    it 'calls SearchQuery::Create' do
      # expect(Parser).to receive(:parse).with(search.query)
      expect(SearchQuery::Create).to receive(:run!).once
      expect { service }.to have_enqueued_job(DownloaderJob).twice
    end
  end

  context 'when the search does not exist' do
    let(:search_id) { 'unexistent' }

    it { expect { service }.to raise_error(ActiveRecord::RecordNotFound) }
  end
end
