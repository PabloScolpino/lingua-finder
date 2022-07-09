# frozen_string_literal: true

class AddContextToResult < ActiveRecord::Migration[5.0]
  def change
    add_column :results, :context, :string
  end
end
