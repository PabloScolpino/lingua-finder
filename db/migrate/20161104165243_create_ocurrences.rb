class CreateOcurrences < ActiveRecord::Migration[5.0]
  def change
    create_table :ocurrences do |t|
      t.string :context
      t.references :result, foreign_key: true
      t.references :page, foreign_key: true

      t.timestamps
    end
  end
end
