# frozen_string_literal: true

class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.string :link
      t.text :body

      t.timestamps
    end
  end
end
