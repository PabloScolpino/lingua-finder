class DropPagesTable < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :results, :pages
    drop_table :pages
  end
end
