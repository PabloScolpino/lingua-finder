class DownloaderJob < ApplicationJob
  rescue_from(ActiveRecord::RecordNotFound) do |_exception|
    puts "DownloaderJob failed to find Search id=#{arguments[0]}"
  end

  def perform(search_id:, page_id:)
    Search.download_and_process(search_id, page_id)
  end
end
