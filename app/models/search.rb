# frozen_string_literal: true

class Search < ApplicationRecord
  belongs_to :user
  has_many :results, dependent: :destroy

  validates :query, presence: true

  validate :query_must_follow_grammar

  after_commit :queue_search, on: :create
  before_destroy :check_processing

  # Query google and then queue each link for further processing
  def self.dispatch_downloads(search_id)
    Search.find(search_id).scrape_internet.each do |page_id|
      DownloaderJob.perform_later search_id: search_id, page_id: page_id
    end
  end

  def scrape_internet
    queries.map do |query|
      SearchQuery.process(string: query, config: options)
    end.flatten
  end

  def queries
    parsed_query.strings
  end

  # Download the given link and process the page
  def self.download_and_process(search_id, page_id)
    Search.find(search_id).process_one_page(page_id)
  end

  def pattern
    parsed_query.pattern
  end

  def language
    'es'
  end

  def process_one_page(page_id)
    page = Page.find_or_download_by(id: page_id)
    sentences = split_body(page.body)

    sentences.each do |sentence|
      next unless (matched = pattern.match(sentence))

      add_result(
        word: matched[:target],
        context: sentence,
        page_id: page.id
      )
    end
  rescue PageError
    Rails.logger.warning 'error processing page'
  end

  def add_result(word:, context:, page_id:)
    results.find_or_create_by(word: word, context: context, page_id: page_id)
  end

  def filename
    query.strip do |q|
      q.gsub!(%r{^.*(\\|/)}, '')
      q.gsub!(/[^0-9A-Za-z.\-]/, '_')
    end
  end

  private

  def options
    o = {}
    o[:cr] = "country#{country_code}" if country_code.present?
    o[:language] = language.to_s if language.present?
    o[:fileType] = '-pdf'
    o
  end

  def check_processing
    # TODO: check search status before deleting
  end

  def parsed_query
    @parsed_query ||= Parser.parse(query)
  end

  def queue_search
    FinderJob.perform_later(search_id: id)
  end

  def split_body(body)
    PragmaticSegmenter::Segmenter.new(text: body, language: language).segment
  rescue ArgumentError
    []
  end

  def query_must_follow_grammar
    errors.add(:invalid_query, 'The query is invalid') unless parsed_query.valid?
  rescue StandardError
    errors.add(:error_parsing_query, 'There was an error parsing the query')
  end
end
