# frozen_string_literal: true

class AddPageToResult < ActiveRecord::Migration[5.0]
  def change
    add_reference :results, :page, foreign_key: true
  end
end
