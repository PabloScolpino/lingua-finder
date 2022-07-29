# frozen_string_literal: true

class SearchAddResultsJob < ApplicationJob
  rescue_from(ActiveRecord::RecordNotFound) do |_exception|
    Rails.logger.error "failed to find search_id=#{arguments[0]}"
  end

  def perform(search_id:, page_id:)
    Search::AddResults.run!(search_id: search_id, page_id: page_id)
  end
end
