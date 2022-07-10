# frozen_string_literal: true

class FinderJob < ApplicationJob
  rescue_from(ActiveRecord::RecordNotFound) do |_exception|
    Rails.logger.error "FinderJob Failed to find Serarch id=#{arguments[0]}"
  end

  def perform(search_id:)
    Search.dispatch_downloads(search_id)
  end
end
