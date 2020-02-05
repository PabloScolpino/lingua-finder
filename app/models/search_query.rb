class SearchQuery
  include Mongoid::Document

  field :string, type: String
  field :config, type: Hash
  field :performed, type: Boolean, default: false

  has_and_belongs_to_many :pages

  def self.process(string:, config:)
    query = find_or_create_by(string: string, config: config)
    query.maybe_perform_query
    query.pages.map(&:id)
  end

  def maybe_perform_query
    return if performed?

    update_attribute(:performed, true)
    hit_google.map do |link|
      pages << Page.find_or_create_by(link: link)
    end
  end

  def hit_google
    links = []
    response = GoogleCustomSearchApi.search_and_return_all_results(string, config)
    # TODO: handle api error
    response.each do |page|
      links << page['items'].map { |item| URI.escape(item['link']) }
    end
    links.flatten
  end
end
