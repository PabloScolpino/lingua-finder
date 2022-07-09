# frozen_string_literal: true

class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.string :word
      t.references :search, foreign_key: true

      t.timestamps
    end
  end
end
