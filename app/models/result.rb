class Result < ApplicationRecord
  belongs_to :search

  def page
    Page.find(page_id)
  end
end
