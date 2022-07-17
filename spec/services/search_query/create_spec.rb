# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchQuery::Create, vcr: {} do
  subject(:service) { described_class.run!(string: string, config: config) }

  let(:string) { 'durante la' }
  let(:config) { { cr: 'countryAR', language: 'es-AR', fileType: '-pdf' } }

  let(:google_adapter) { class_double(GoogleCustomSearchApi) }

  before do
    allow(GoogleCustomSearchApi).to receive(:search_and_return_all_results).with(string, config).and_return([result])
    expect(GoogleCustomSearchApi).to receive(:search_and_return_all_results).with(string, config)
  end

  let(:result) { build(:google_custom_search_api_result, :with_results, result_count: 3) }

  it { is_expected.to be_a(SearchQuery) }

  context 'when results are found' do
    it 'stores the pages' do
      expect { service }.to change(SearchQuery, :count).by(1).and(change(Page, :count).by(3))
    end
  end
end
