# frozen_string_literal: true

class DeleteOcurrenceTable < ActiveRecord::Migration[5.0]
  def up
    drop_table :ocurrences
  end

  def down
    create_table 'ocurrences', force: :cascade do |t|
      t.string   'context'
      t.integer  'result_id'
      t.integer  'page_id'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['page_id'], name: 'index_ocurrences_on_page_id'
      t.index ['result_id'], name: 'index_ocurrences_on_result_id'
    end
  end
end
