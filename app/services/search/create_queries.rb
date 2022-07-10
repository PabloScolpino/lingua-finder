# frozen_string_literal: true

class Search
  class CreateQueries < ApplicationInteraction
    string :search_id

    def execute
      ap search
      queue_page_downloads(create_search_queries)
    end

    private

    def search
      @search ||= Search.find(search_id)
    end

    def queries
      Parser.parse(search.query).strings
    end

    def create_search_queries
      queries.each_with_object([]) do |query, search_queries|
        search_queries << SearchQuery::Create.run!(string: query, config: search_query_config)
      end
    end

    def search_query_config
      o = {}
      o[:cr] = "country#{search.country_code}" if search.country_code.present?
      o[:language] = search.language.to_s if search.language.present?
      o[:fileType] = '-pdf'
      o
    end

    def queue_page_downloads(search_queries)
      search_queries.each do |search_query|
        search_query.pages.each do |page|
          DownloaderJob.perform_later search_id: search_id, page_id: page.id
        end
      end
    end
  end
end
