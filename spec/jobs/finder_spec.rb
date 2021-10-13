require 'rails_helper'

RSpec.describe FinderJob, type: :job, vcr: {} do
  xdescribe '#perform' do
    let(:search) { create(:search) }
    let(:queue_name) { "#{Rails.env}.default" }

    it 'performs a search' do
      expect(Search).to receive(:dispatch_downloads).with(search_id)
    end
  end
end
