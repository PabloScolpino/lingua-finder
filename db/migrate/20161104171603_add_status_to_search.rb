# frozen_string_literal: true

class AddStatusToSearch < ActiveRecord::Migration[5.0]
  def change
    add_column :searches, :status, :string
  end
end
