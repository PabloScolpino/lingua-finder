class DownloaderJob < ApplicationJob
  rescue_from(ActiveRecord::StatementInvalid) do |exception|
    puts '-------------------------------------------------------------'
    puts exception.inspect
    puts self.inspect
    puts '-------------------------------------------------------------'
  end

  def perform(search_id:, link:)
    Search.download_and_process(search_id, link)
  end
end
