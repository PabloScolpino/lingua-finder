# frozen_string_literal: true

class SearchQuery
  include Mongoid::Document

  field :string, type: String
  field :config, type: Hash
  field :performed, type: Boolean, default: false

  has_and_belongs_to_many :pages
end
