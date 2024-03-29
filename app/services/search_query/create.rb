# frozen_string_literal: true

class SearchQuery
  class Create < ApplicationInteraction
    string :string
    hash :config do
      string :cr
      string :language
      string :fileType
    end

    def execute
      perform_query unless query.performed?
      query
    end

    private

    def query
      @query ||= SearchQuery.find_or_create_by(string: string, config: config)
    end

    def perform_query
      links_from_google_search.each do |link|
        query.pages << Page.find_or_create_by(link: link)
      end

      query.update_attribute(:performed, true)
    end

    def links_from_google_search
      google_response.each_with_object([]) do |page, links|
        links << page['items'].map { |item| CGI.escape(item['link']) }
      end.flatten
    end

    def google_response
      results = GoogleCustomSearchApi.search_and_return_all_results(string, config)
      raise 'Empty Google Response' if results.empty?

      results
    end
  end
end
