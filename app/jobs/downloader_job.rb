class DownloaderJob < ApplicationJob
  rescue_from(ActiveRecord::StatementInvalid) do |exception|
    puts '-------------------------------------------------------------'
    puts exception.inspect
    puts self.inspect
    puts '-------------------------------------------------------------'
  end

  def perform(search_id:, link:)
    self.search = Search.find(search_id)
    process_one_page(link)
  end

  private

  attr_accessor :search

  def process_one_page(link)
    page = Page.find_or_download(link)

    sentences = split_body(page.body)

    sentences.each do |sentence|
      if matched = search.pattern.match(sentence)
        search.add_result({word: matched[:target], context: sentence, page: page})
      end
    end
  end

  def split_body(body)
    PragmaticSegmenter::Segmenter.new(text: body, language: search.language ).segment
  end
end
