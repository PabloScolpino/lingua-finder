# frozen_string_literal: true

json.array! @words, partial: 'words/word', as: :word
