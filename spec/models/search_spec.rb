# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search, type: :model, vcr: {} do
  include ActiveJob::TestHelper

  describe 'query validation' do
    subject { create(:search, query: query) }

    context 'invalid query' do
      let(:query) { 'durante' }

      it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
    end

    context 'invalid query 2' do
      let(:query) { '<?>' }

      it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
    end

    context 'valid query' do
      let(:query) { 'durante la <?>' }

      it { expect { subject }.not_to raise_error }
    end
  end
end
