class AddStatusToSearch < ActiveRecord::Migration[5.0]
  def change
    add_column :searches, :status, :string
  end
end
