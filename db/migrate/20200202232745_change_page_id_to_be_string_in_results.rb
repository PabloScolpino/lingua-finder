class ChangePageIdToBeStringInResults < ActiveRecord::Migration[5.0]
  def change
    change_column :results, :page_id, :string
  end
end
