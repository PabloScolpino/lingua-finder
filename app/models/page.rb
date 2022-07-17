# frozen_string_literal: true

class Page
  include Mongoid::Document

  field :link, type: String
  field :body, type: String

  has_and_belongs_to_many :search_queries

  def id
    self[:_id].to_s
  end
end
