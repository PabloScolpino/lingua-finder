class Search < ApplicationRecord
  has_many :results, dependent: :destroy

  validates :query, presence: true

  after_commit :queue_search, on: :create
  before_destroy :check_processing

  def scrape_internet
    self.queries.map do |q|
      query_google(q)
    end.flatten
  end

  def add_result(word: , context: , page: )
    self.results.find_or_create_by(word: word, context: context, page: page)
  end

  def pattern
    formated_query = query.gsub('<?>','(?<target>[[:alpha:]]+)')
    Regexp.new(formated_query)
  end

  def language
    'es'
  end

  def queries
    formated_query = query.gsub('<?>','')
    formated_query.sub!(/^\s*/,'allintext:"')
    formated_query.sub!(/\s*$/,'"')
    [ formated_query ]
  end

  private

  def query_google(q)
    # todo cache queries

    r = []
    response = GoogleCustomSearchApi.search_and_return_all_results(q, options)
    # todo handle api error
    response.each do |page|
      r << page['items'].map { |item| item['link'] }
    end
    r
  end

  def options
    o = {}
    o[:cr] = "country#{country_code}" if country_code.present?
    o[:language] = "#{language}" if language.present?
    o[:fileType] = '-pdf'
    o
  end

  def check_processing
    # TODO check search status before deleting
  end

  def queue_search
    FinderJob.perform_later(search_id: self.id)
  end
end
