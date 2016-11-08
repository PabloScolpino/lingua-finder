require 'rails_helper'

RSpec.describe FinderJob, type: :job, vcr: {} do
  include ActiveJob::TestHelper

  let(:search) {Search.create( query: 'durante el <?>', country_code: 'AR')}

  #let(:job) { described_class.perform_later( search_id: search.id) }

  it 'can search and parse a result' do
    assert_performed_with(
      job: FinderJob,
      args: [{search_id: search.id}],
      queue: 'default'
    ) do
      FinderJob.perform_later search_id: search.id
    end

    expect(search.results.count).to be > 0
  end

  it 'queues the job' do
    expect { search }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  #it 'executes perform' do
    #expect(FinderJob).to receive(:perform_later).with( search_id: search.id)
  #end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
