# frozen_string_literal: true

# NOTE: This needs to be on SEARCH namespace
class Search
  class AddResults < ApplicationInteraction
    string :search_id # a search is needed to have the patterns
    string :page_id

    def execute
      process_one_page
    end

    private

    def search
      Search.find(search_id)
    end

    def page
      @page ||= Page::Get.run!(id: page_id)
    end

    def parsed_query
      @parsed_query ||= Parser.parse(search.query)
    end

    def sentences
      PragmaticSegmenter::Segmenter.new(text: page.body, language: search.language).segment
    rescue ArgumentError
      []
    end

    def process_one_page
      sentences.each do |sentence|
        next unless (matched = parsed_query.pattern.match(sentence))

        add_result(
          word: matched[:target],
          context: sentence,
          page_id: page.id
        )
      end
    rescue PageError
      Rails.logger.warn 'error processing page'
    end

    def add_result(word:, context:, page_id:)
      search.results.find_or_create_by(word: word, context: context, page_id: page_id)
    end
  end
end
