# frozen_string_literal: true

require 'rails_helper'

describe Search::AddResults do
  subject(:service) { described_class.run!(search_id: search_id, page_id: page_id) }

  let(:search) { create(:search, query: 'durante la <?>') }
  let(:search_id) { search.id.to_s }
  let(:page) { create(:page, body: page_body) }
  let(:page_id) { page.id }
  let(:page_body) { 'some content' }

  context 'when the search exists' do
    context 'when the page exists' do
      context 'when the page context matches' do
        let(:page_body) { 'asdfasdf durante la comida asdf asdf' }

        it 'adds results to the search' do
          expect { service }.to change { search.results.count }.from(0).to(1)
        end
      end

      context 'when the page context does NOT match' do
        let(:page_body) { 'asdfasdf mientras que la comida asdf asdf' }

        it 'does not add results to the search' do
          expect { service }.not_to change(search.results, :count)
        end
      end
    end

    context 'when the page does NOT exists' do
      let(:page_id) { 'unexistent' }
      it { expect { service }.to raise_error(Mongoid::Errors::DocumentNotFound) }
    end
  end

  context 'when the search does NOT exist' do
    let(:search_id) { 'unexistent' }

    it { expect { service }.to raise_error(ActiveRecord::RecordNotFound) }
  end
end
