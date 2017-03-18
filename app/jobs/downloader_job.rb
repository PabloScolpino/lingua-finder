class DownloaderJob < ApplicationJob
  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    puts "DownloaderJob failed to find Search id=#{arguments[0]}"
  end

  def perform(search_id:, link:)
    Search.download_and_process(search_id, link)
  end
end
