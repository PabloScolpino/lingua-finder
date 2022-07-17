# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Page::Get do
  subject(:service) { described_class.run!(id: page_id) }

  let(:page_id) {}

  context 'when the page exists' do
    let(:page) { create :page }
    let(:page_id) { page.id }

    context 'when the page has not been downloaded before' do
      context 'when the page exists' do
        before do
          stub_request(:get, page.link).to_return(status: 200, body: 'content')
        end

        it { expect(service).to be_a(Page) }

        it 'downloads and stores the page' do
          service
          page.reload
          expect(page.body).to eq('content')
        end
      end

      context 'when the website DOES NOT exist' do
        before do
          stub_request(:get, page.link).to_return(status: 404)
        end

        it { expect(service).to be_a(Page) }

        it 'stores an empty page' do
          service
          expect(page.body).to be nil
        end
      end
    end

    context 'when the page has been downloaded before' do
      let(:page) { create :page, body: 'content' }

      it { expect(service).to be_a(Page) }

      it 'does NOT download it again' do
        expect(HTTParty).not_to receive(:get).with(page.link, headers: { 'User-Agent' => Page::Get::USER_AGENT })

        service
      end
    end
  end

  context 'when the page does not exist' do
    let(:page_id) { '123' }

    it { expect { service }.to raise_error(Mongoid::Errors::DocumentNotFound) }
  end
end
