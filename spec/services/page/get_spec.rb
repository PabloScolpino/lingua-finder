# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Page::Get do
  subject(:service) { described_class.run!(id: page.id) }

  let(:page) { create :page }

  context 'when the page has not been downloaded before' do
    context 'when the page exists' do
      before do
        stub_request(:get, page.link).to_return(status: 200, body: 'content')
      end

      it 'downloads and stores the page' do
        service
        page.reload
        expect(page.body).to eq('content')
      end
    end

    context 'when the page DOES NOT exist' do
      before do
        stub_request(:get, page.link).to_return(status: 404)
      end

      it 'xxx' do
        service
        expect(page.body).to be nil
      end
    end
  end

  context 'when the page has been downloaded before' do
    let(:page) { create :page, body: 'content' }

    it 'does NOT download it again' do
      expect(HTTParty).not_to receive(:get).with(page.link, headers: { 'User-Agent' => Page::Get::USER_AGENT })

      service
    end
  end
end
