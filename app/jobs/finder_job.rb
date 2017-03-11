class FinderJob < ApplicationJob
  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    puts '-------------------------------------------------------------'
    puts exception.inspect
    puts @search_id
    puts '-------------------------------------------------------------'
  end

  def perform(search_id:)
    Search.dispatch_downloads(search_id)
  end
end
