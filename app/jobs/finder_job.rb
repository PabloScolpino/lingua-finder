class FinderJob < ApplicationJob
  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    puts '-------------------------------------------------------------'
    puts exception.inspect
    puts @search_id
    puts '-------------------------------------------------------------'
  end

  def perform(search_id:)
    @search_id = search_id
    search = Search.find(@search_id)
    search.scrape_internet.each do |link|
      puts "Dispatching download of #{link} ..."
      DownloaderJob.perform_later search_id: search.id, link: link
    end
  end
end
