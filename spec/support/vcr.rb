# frozen_string_literal: true

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join('spec', 'vcr_cassettes')
  config.hook_into :webmock
  config.default_cassette_options = { record: :new_episodes }
  config.allow_http_connections_when_no_cassette = false
  config.configure_rspec_metadata!

  # config.debug_logger = $stderr
end
