class AddCountryCodeToSearch < ActiveRecord::Migration[5.0]
  def change
    add_column :searches, :country_code, :string
  end
end
