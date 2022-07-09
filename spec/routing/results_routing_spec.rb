# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResultsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/searches/1/results/pepe').to route_to('results#index', search_id: '1', word: 'pepe',
                                                                           exept: %i[edit update])
    end

    it 'routes to #show' do
      expect(get: '/searches/1/results/pepe/1').to route_to('results#show', id: '1', search_id: '1', word: 'pepe',
                                                                            exept: %i[edit update])
    end
  end
end
