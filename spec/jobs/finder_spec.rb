require 'rails_helper'

RSpec.describe FinderJob, type: :job, vcr: {} do

  let(:search) {Search.create( query: 'durante la <?>', country_code: 'AR')}
  let(:queue_name) { "#{Rails.env}.default" }

  it 'gets queued properly' do
    assert_performed_with(
      job: FinderJob,
      args: [{search_id: search.id}],
      queue: queue_name
    ) do
      FinderJob.perform_later search_id: search.id
    end
  end

  it 'gets queued by new search' do
    expect { search }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
