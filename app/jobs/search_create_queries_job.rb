# frozen_string_literal: true

class SearchCreateQueriesJob < ApplicationJob
  rescue_from(ActiveRecord::RecordNotFound) do |_exception|
    Rails.logger.error "Failed to find Serarch id=#{arguments[0]}"
  end

  def perform(search_id:)
    Search::CreateQueries.run!(search_id: search_id)
  end
end
