# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchQuery::Create, vcr: {} do
  subject(:service) { described_class.run!(string: string, config: config) }

  let(:string) { 'durante la' }
  let(:config) { { cr: 'countryAR', language: 'es-AR', fileType: '-pdf' } }

  context 'when results are found' do
    it 'stores the pages' do
      expect { service }.to change(SearchQuery, :count).by(1).and(change(Page, :count).by(100))
    end
  end
end
