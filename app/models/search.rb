# frozen_string_literal: true

class Search < ApplicationRecord
  belongs_to :user
  has_many :results, dependent: :destroy

  validates :query, presence: true

  validate :query_must_follow_grammar

  after_commit :queue_search, on: :create
  before_destroy :check_processing

  def language
    'es'
  end

  def filename
    query.strip do |q|
      q.gsub!(%r{^.*(\\|/)}, '')
      q.gsub!(/[^0-9A-Za-z.\-]/, '_')
    end
  end

  def queue_search
    SearchCreateQueriesJob.perform_later(search_id: id.to_s)
  end

  private

  def check_processing
    # TODO: check search status before deleting
  end

  def parsed_query
    @parsed_query ||= Parser.parse(query)
  end

  def query_must_follow_grammar
    errors.add(:invalid_query, 'The query is invalid') unless parsed_query.valid?
  rescue StandardError
    errors.add(:error_parsing_query, 'There was an error parsing the query')
  end

end
