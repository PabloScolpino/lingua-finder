# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DownloaderJob, type: :job, vcr: {} do
  let(:search) { create(:search) }
  let(:link) { 'http://www.ospana.com.ar/index.php/temas-de-salud/78-cuidados-durante-el-embarazo.html' }
  let(:page) { create(:page, link: link) }
  let(:queue_name) { "#{Rails.env}.default" }

  it 'gets queued properly' do
    assert_performed_with(
      job: DownloaderJob,
      args: [{ search_id: search.id, page_id: page.id }],
      queue: queue_name
    ) do
      DownloaderJob.perform_later search_id: search.id, page_id: page.id
    end
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
